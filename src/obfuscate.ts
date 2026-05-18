import { exec } from 'child_process';
import tmp from 'tmp';
import path from 'path';
import fs from 'fs';

const PROMETHEUS_DIR = path.join(process.cwd(), 'prometheus');
const IRONBREW_DIR = path.join(process.cwd(), 'ironbrew');
const IRONBREW_DLL = path.join(IRONBREW_DIR, 'IronBrew2 CLI.dll');

const PRESET_MAP: Record<string, string> = {
    Weak: 'Weak',
    Medium: 'Medium',
    Strong: 'Strong',
};

function runCommand(cmd: string): Promise<void> {
    return new Promise((resolve, reject) => {
        exec(cmd, (error, stdout, stderr) => {
            if (error) reject(stderr || error.message);
            else resolve();
        });
    });
}

export default async function obfuscate(inputFile: string, preset: string): Promise<tmp.SynchrounousResult> {
    const prometheusPreset = PRESET_MAP[preset] || 'Weak';

    // Paso 1: Prometheus
    const prometheusOut = tmp.fileSync({ postfix: '.lua' });
    await runCommand(
        `cd "${PROMETHEUS_DIR}" && lua "src/cli.lua" --preset ${prometheusPreset} --out "${prometheusOut.name}" "${inputFile}"`
    );
    if (!fs.existsSync(prometheusOut.name) || fs.readFileSync(prometheusOut.name).length === 0) {
        throw new Error('Prometheus obfuscation failed.');
    }

    // Paso 2: IronBrew2 sobre el output de Prometheus
    const inputCopy = path.join(IRONBREW_DIR, 'input.txt');
    fs.copyFileSync(prometheusOut.name, inputCopy);
    prometheusOut.removeCallback();

    await runCommand(`cd "${IRONBREW_DIR}" && dotnet "IronBrew2 CLI.dll" "input.txt"`);

    const outLua = path.join(IRONBREW_DIR, 'out.lua');
    if (!fs.existsSync(outLua) || fs.readFileSync(outLua).length === 0) {
        throw new Error('IronBrew2 obfuscation failed.');
    }

    const content = fs.readFileSync(outLua, 'utf8');
    const outFile = tmp.fileSync({ postfix: '.lua' });
    fs.writeFileSync(outFile.name, '-- obfuscated by y8y9 obf https://discord.gg/2DQbVrXJ8A\n' + content, 'utf8');

    return outFile;
}
