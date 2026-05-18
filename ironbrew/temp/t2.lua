
local Byte         = string.byte;
local Char         = string.char;
local Sub          = string.sub;
local Concat       = table.concat;
local LDExp        = math.ldexp;
local GetFEnv      = getfenv or function() return _ENV end;
local Setmetatable = setmetatable;
local Select       = select;

local Unpack = unpack;
local ToNumber = tonumber;local function decompress(b)local c,d,e="","",{}local f=256;local g={}for h=0,f-1 do g[h]=Char(h)end;local i=1;local function k()local l=ToNumber(Sub(b, i,i),36)i=i+1;local m=ToNumber(Sub(b, i,i+l-1),36)i=i+l;return m end;c=Char(k())e[1]=c;while i<#b do local n=k()if g[n]then d=g[n]else d=c..Sub(c, 1,1)end;g[f]=c..Sub(d, 1,1)e[#e+1],c,f=d,d,f+1 end;return table.concat(e)end;local ByteString=decompress('21H21L21H27621G21G27621H25S21G21C27A21X21Z22K22J21T27927A21G21F27A21Y21T27H22J22A21G21I27P21S22F21G21D27A22E22L22C21Z27W27A28828727A25X22I23928A27A25H1A27V27A24X2721U28F27621P28E28827A23928822C27A24B21P25H25M1Z21P27624229321H21B29624321929021B21929429E29729G24221921129H27623V29B25M29D27623R1L29C1L27623Q1522T2971527623N29U29Q29W21H23M1D22D2971D27625A27A21427A2571D29021D2AD21H2532392AL28U21H24Z23H2AL23H2762542A51529W25124Q2AN172AN24M2AB21H172B924Q21129W1F29L21H25A22D26D21H122B925A22L26T2BM22L2AY27125M25M2182BV22225722T2AL2A02AO2AV25M21D2AX21H24Y29G1M29G24V2C62C827625026525G25M1526521G25124M22L24L21H21G2BT21H24M21X23P21H21Q21X2762CY2CT21B2D321H24I1T27621B2DB21H2662A721B2A72622A22A127625Y29G29R21H25U2CW21B2CW25Q2DT2CW2621L29W2DI27626223921121G21B2AS25Y2DL172DL25U2C92132C925Q2D82D727625M2EJ2D825Y2E02972A725Y2391L2E72AS25Q2592DC2EZ21H25M2CT2972F425R24529C24527625Q2FA2972FD2FC29L21B2FD25J2CG2C925F2AK2C72AN23L25123921G21125121H25124C2252901T2252FX23L21P22T21G21O2932FY27A2DE2FY22D2G12AB2512722452BR21P2FD26Y24D2GL24D27627121P24L21G1D2GA24C21H2G127625125E23X22D21G21523X27626U24525121G1X2FD26U26D2BR21N2BL21H26Q24D2GV21B2GR2HM26L2BR21B26L27625I23P2HU2D02F22HW2972I325Q2HL21B2HL24C22L2BW2DU25M22225P2G621G1B2GY2H025M2GD25Q2HR172HR23L23H2FT2112AX2FY2AQ2IM28U2GI2GK21H2GM2762G52HD2112IK2H12FX2H42H62H827626Y2HC2HE2GN2712BR21L2712HX2HZ21H1Q2I125Q2JN2BA2JU24C2452BW1T2JY2222662H92BA2K42622BR2BA2K824M27A1827A24C25P21M21H1T25P2IE26628U21G1E2AS23U2G32792G321H25021H25N2BX2KX22224E2DE172DE24A2EB2DL24A2KC2KE2KG2KI2KK22224B2112901V2BH24627A1727A24A21129L1S2BH24E29614296');

local BitXOR = bit and bit.bxor or function(a,b)
    local p,c=1,0
    while a>0 and b>0 do
        local ra,rb=a%2,b%2
        if ra~=rb then c=c+p end
        a,b,p=(a-ra)/2,(b-rb)/2,p*2
    end
    if a<b then a=b end
    while a>0 do
        local ra=a%2
        if ra>0 then c=c+p end
        a,p=(a-ra)/2,p*2
    end
    return c
end

local function gBit(Bit, Start, End)
	if End then
		local Res = (Bit / 2 ^ (Start - 1)) % 2 ^ ((End - 1) - (Start - 1) + 1);

		return Res - Res % 1;
	else
		local Plc = 2 ^ (Start - 1);

        return (Bit % (Plc + Plc) >= Plc) and 1 or 0;
	end;
end;

local Pos = 1;

local function gBits32()
    local W, X, Y, Z = Byte(ByteString, Pos, Pos + 3);

	W = BitXOR(W, 53)
	X = BitXOR(X, 53)
	Y = BitXOR(Y, 53)
	Z = BitXOR(Z, 53)

    Pos	= Pos + 4;
    return (Z*16777216) + (Y*65536) + (X*256) + W;
end;

local function gBits8()
    local F = BitXOR(Byte(ByteString, Pos, Pos), 53);
 local __a__,v,owo = nil,nil,nil; local Trace = debug.traceback() Trace = string.match(Trace, '%d+') if tonumber(Trace) >= 2 then error('Attempt lol ig') end   Pos = Pos + 1;
    return F;
end;

local function gFloat()
	local Left = gBits32();
	local Right = gBits32();
	local IsNormal = 1;
	local Mantissa = (gBit(Right, 1, 20) * (2 ^ 32))
					+ Left;
	local Exponent = gBit(Right, 21, 31);
	local Sign = ((-1) ^ gBit(Right, 32));
	if (Exponent == 0) then
		if (Mantissa == 0) then
			return Sign * 0; -- +-0
		else
			Exponent = 1;
			IsNormal = 0;
		end;
	elseif (Exponent == 2047) then
        return (Mantissa == 0) and (Sign * (1 / 0)) or (Sign * (0 / 0));
	end;
	return LDExp(Sign, Exponent - 1023) * (IsNormal + (Mantissa / (2 ^ 52)));
end;

local gSizet = gBits32;
local function gString(Len)
    local Str;
    if (not Len) then
        Len = gSizet();
        if (Len == 0) then
            return '';
        end;
    end;

    Str	= Sub(ByteString, Pos, Pos + Len - 1);
    Pos = Pos + Len;

	local FStr = {}
	for Idx = 1, #Str do
		FStr[Idx] = Char(BitXOR(Byte(Sub(Str, Idx, Idx)), 53))
	end

    return Concat(FStr);
end;

local gInt = gBits32;
local function _R(...) return {...}, Select('#', ...) end

local function Deserialize()
    local Instrs = { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 };
    local Functions = {  };
	local Lines = {};
    local Chunk = 
	{
		Instrs,
		nil,
		Functions,
		nil,
		Lines
	};Chunk[4] = gBits8();
								local ConstCount = gBits32()
    							local Consts = {0,0,0,0,0,0,0,0,0,0,0,0};

								for Idx=1,ConstCount do 
									local Type=gBits8();
									local Cons;
	
									if(Type==0) then Cons=(gBits8() ~= 0);
									elseif(Type==3) then Cons = gFloat();
									elseif(Type==1) then Cons=gString();
									end;
									
									Consts[Idx]=Cons;
								end;
								Chunk[2] = Consts
								for Idx=1,gBits32() do Functions[Idx-1]=Deserialize();end;for Idx=1,gBits32() do 
									local Data1=BitXOR(gBits32(),171);
									local Data2=BitXOR(gBits32(),26); 

									local Type=gBit(Data1,1,2);
									local Opco=gBit(Data2,1,11);
									
									local Inst=
									{
										Opco,
										gBit(Data1,3,11),
										nil,
										nil,
										Data2
									};

									if (Type == 0) then Inst[3]=gBit(Data1,12,20);Inst[5]=gBit(Data1,21,29);
									elseif(Type==1) then Inst[3]=gBit(Data2,12,33);
									elseif(Type==2) then Inst[3]=gBit(Data2,12,32)-1048575;
									elseif(Type==3) then Inst[3]=gBit(Data2,12,32)-1048575;Inst[5]=gBit(Data1,21,29);
									end;
									
									Instrs[Idx]=Inst;end;return Chunk;end;
local function Wrap(Chunk, Upvalues, Env)
	local Instr  = Chunk[1];
	local Const  = Chunk[2];
	local Proto  = Chunk[3];
	local Params = Chunk[4];

	return function(...)
		local Instr  = Instr; 
		local Const  = Const; 
		local Proto  = Proto; 
		local Params = Params;

		local _R = _R
		local InstrPoint = 1;
		local Top = -1;

		local Vararg = {};
		local Args	= {...};

		local PCount = Select('#', ...) - 1;

		local Lupvals	= {};
		local Stk		= {};

		for Idx = 0, PCount do
			if (Idx >= Params) then
				Vararg[Idx - Params] = Args[Idx + 1];
			else
				Stk[Idx] = Args[Idx + 1];
			end;
		end;

		local Varargsz = PCount - Params + 1

		local Inst;
		local Enum;	

		while true do
			Inst		= Instr[InstrPoint];
			Enum		= Inst[1];if Enum <= 28 then if Enum <= 13 then if Enum <= 6 then if Enum <= 2 then if Enum <= 0 then Stk[Inst[2]]=#Stk[Inst[3]]; elseif Enum == 1 then if(Stk[Inst[2]]~=Stk[Inst[5]])then InstrPoint=InstrPoint+1;else InstrPoint=InstrPoint+Inst[3];end;else Stk[Inst[2]]=Stk[Inst[3]]+Const[Inst[5]];end; elseif Enum <= 4 then if Enum > 3 then Stk[Inst[2]]=Stk[Inst[3]][Const[Inst[5]]];else local A=Inst[2];local Step=Stk[A+2];local Index=Stk[A]+Step;Stk[A]=Index;if Step>0 then if Index<=Stk[A+1] then InstrPoint=InstrPoint+Inst[3];Stk[A+3]=Index;end;elseif Index>=Stk[A+1] then InstrPoint=InstrPoint+Inst[3];Stk[A+3]=Index;end;end; elseif Enum > 5 then Stk[Inst[2]]=Stk[Inst[3]]+Stk[Inst[5]];else local A=Inst[2];Stk[A]=Stk[A]-Stk[A+2];InstrPoint=InstrPoint+Inst[3];end; elseif Enum <= 9 then if Enum <= 7 then Stk[Inst[2]]={}; elseif Enum == 8 then local Results;local Limit;local Edx;local Args;local A;Stk[Inst[2]]=Stk[Inst[3]];InstrPoint = InstrPoint + 1;Inst = Instr[InstrPoint];Stk[Inst[2]]=Stk[Inst[3]];InstrPoint = InstrPoint + 1;Inst = Instr[InstrPoint];Stk[Inst[2]]=Stk[Inst[3]];InstrPoint = InstrPoint + 1;Inst = Instr[InstrPoint];A=Inst[2];Args={};Edx=0;Limit=A+Inst[3]-1;for Idx=A+1,Limit do Edx=Edx+1;Args[Edx]=Stk[Idx];end;Results={Stk[A](Unpack(Args,1,Limit-A))};Limit=A+Inst[5]-2;Edx=0;for Idx=A,Limit do Edx=Edx+1;Stk[Idx]=Results[Edx];end;Top=Limit;InstrPoint = InstrPoint + 1;Inst = Instr[InstrPoint];Stk[Inst[2]]=Stk[Inst[3]][Stk[Inst[5]]];InstrPoint = InstrPoint + 1;Inst = Instr[InstrPoint];Stk[Inst[2]]=Stk[Inst[3]];InstrPoint = InstrPoint + 1;Inst = Instr[InstrPoint];Stk[Inst[2]]=Stk[Inst[3]];InstrPoint = InstrPoint + 1;Inst = Instr[InstrPoint];Stk[Inst[2]]=Stk[Inst[3]];InstrPoint = InstrPoint + 1;Inst = Instr[InstrPoint];Stk[Inst[2]]=Stk[Inst[3]];InstrPoint = InstrPoint + 1;Inst = Instr[InstrPoint];Stk[Inst[2]]=Stk[Inst[3]];else Stk[Inst[2]]=Env[Const[Inst[3]]];end; elseif Enum <= 11 then if Enum > 10 then Stk[Inst[2]][Stk[Inst[3]]]=Stk[Inst[5]];else if(Const[Inst[2]]<Stk[Inst[5]])then InstrPoint=InstrPoint+1;else InstrPoint=InstrPoint+Inst[3];end;end; elseif Enum == 12 then Stk[Inst[2]]=Const[Inst[3]];InstrPoint = InstrPoint + 1;Inst = Instr[InstrPoint];Stk[Inst[2]]=Stk[Inst[3]];InstrPoint = InstrPoint + 1;Inst = Instr[InstrPoint];Stk[Inst[2]]=Stk[Inst[3]];InstrPoint = InstrPoint + 1;Inst = Instr[InstrPoint];Stk[Inst[2]]=Stk[Inst[3]];InstrPoint = InstrPoint + 1;Inst = Instr[InstrPoint];Stk[Inst[2]]=Stk[Inst[3]];InstrPoint = InstrPoint + 1;Inst = Instr[InstrPoint];Stk[Inst[2]]=Const[Inst[3]];InstrPoint = InstrPoint + 1;Inst = Instr[InstrPoint];Stk[Inst[2]]=Env[Const[Inst[3]]];InstrPoint = InstrPoint + 1;Inst = Instr[InstrPoint];Stk[Inst[2]]=Stk[Inst[3]][Const[Inst[5]]];InstrPoint = InstrPoint + 1;Inst = Instr[InstrPoint];Stk[Inst[2]]=Env[Const[Inst[3]]];InstrPoint = InstrPoint + 1;Inst = Instr[InstrPoint];Stk[Inst[2]]=Stk[Inst[3]][Const[Inst[5]]];else if(Const[Inst[2]]<Stk[Inst[5]])then InstrPoint=InstrPoint+1;else InstrPoint=InstrPoint+Inst[3];end;end; elseif Enum <= 20 then if Enum <= 16 then if Enum <= 14 then Stk[Inst[2]]=Stk[Inst[3]]-Stk[Inst[5]]; elseif Enum == 15 then Stk[Inst[2]]=Stk[Inst[3]]*Const[Inst[5]];else Stk[Inst[2]]={};end; elseif Enum <= 18 then if Enum > 17 then Stk[Inst[2]]=Stk[Inst[3]]%Const[Inst[5]];else local Results;local Limit;local Edx;local Args;local A;Stk[Inst[2]]=Stk[Inst[3]]%Const[Inst[5]];InstrPoint = InstrPoint + 1;Inst = Instr[InstrPoint];Stk[Inst[2]]=Stk[Inst[3]]+Const[Inst[5]];InstrPoint = InstrPoint + 1;Inst = Instr[InstrPoint];Stk[Inst[2]]=Stk[Inst[3]];InstrPoint = InstrPoint + 1;Inst = Instr[InstrPoint];Stk[Inst[2]]=Stk[Inst[3]];InstrPoint = InstrPoint + 1;Inst = Instr[InstrPoint];Stk[Inst[2]]=Stk[Inst[3]];InstrPoint = InstrPoint + 1;Inst = Instr[InstrPoint];Stk[Inst[2]]=Stk[Inst[3]];InstrPoint = InstrPoint + 1;Inst = Instr[InstrPoint];Stk[Inst[2]]=Stk[Inst[3]];InstrPoint = InstrPoint + 1;Inst = Instr[InstrPoint];Stk[Inst[2]]=Stk[Inst[3]];InstrPoint = InstrPoint + 1;Inst = Instr[InstrPoint];A=Inst[2];Args={};Edx=0;Limit=A+Inst[3]-1;for Idx=A+1,Limit do Edx=Edx+1;Args[Edx]=Stk[Idx];end;Results={Stk[A](Unpack(Args,1,Limit-A))};Limit=A+Inst[5]-2;Edx=0;for Idx=A,Limit do Edx=Edx+1;Stk[Idx]=Results[Edx];end;Top=Limit;InstrPoint = InstrPoint + 1;Inst = Instr[InstrPoint];Stk[Inst[2]]=Stk[Inst[3]][Stk[Inst[5]]];end; elseif Enum == 19 then if(Const[Inst[2]]>=Stk[Inst[5]])then InstrPoint=InstrPoint+1;else InstrPoint=InstrPoint+Inst[3];end;else Stk[Inst[2]]=Stk[Inst[3]]/Const[Inst[5]];InstrPoint = InstrPoint + 1;Inst = Instr[InstrPoint];Stk[Inst[2]]=Stk[Inst[3]]-Stk[Inst[5]];InstrPoint = InstrPoint + 1;Inst = Instr[InstrPoint];Stk[Inst[2]]=Stk[Inst[3]]/Const[Inst[5]];InstrPoint = InstrPoint + 1;Inst = Instr[InstrPoint];Stk[Inst[2]]=Stk[Inst[3]]*Const[Inst[5]];InstrPoint = InstrPoint + 1;Inst = Instr[InstrPoint];Stk[Inst[2]]=Stk[Inst[3]];InstrPoint = InstrPoint + 1;Inst = Instr[InstrPoint];Stk[Inst[2]]=Stk[Inst[3]];InstrPoint = InstrPoint + 1;Inst = Instr[InstrPoint];InstrPoint=InstrPoint+Inst[3];end; elseif Enum <= 24 then if Enum <= 22 then if Enum > 21 then Stk[Inst[2]]=Stk[Inst[3]]/Const[Inst[5]];else Stk[Inst[2]]=Stk[Inst[3]]+Const[Inst[5]];end; elseif Enum == 23 then if(Stk[Inst[2]]<Stk[Inst[5]])then InstrPoint=InstrPoint+1;else InstrPoint=InstrPoint+Inst[3];end;else local B=Inst[3];local K=Stk[B] for Idx=B+1,Inst[5] do K=K..Stk[Idx];end;Stk[Inst[2]]=K;end; elseif Enum <= 26 then if Enum == 25 then InstrPoint=InstrPoint+Inst[3];else local B=Inst[3];local K=Stk[B] for Idx=B+1,Inst[5] do K=K..Stk[Idx];end;Stk[Inst[2]]=K;end; elseif Enum > 27 then local A=Inst[2];local Args={};local Edx=0;local Limit=A+Inst[3]-1;for Idx=A+1,Limit do Edx=Edx+1;Args[Edx]=Stk[Idx];end;Stk[A](Unpack(Args,1,Limit-A));Top=A;else Stk[Inst[2]]=Stk[Inst[3]]-Const[Inst[5]];end; elseif Enum <= 42 then if Enum <= 35 then if Enum <= 31 then if Enum <= 29 then Stk[Inst[2]]=Stk[Inst[3]][Const[Inst[5]]]; elseif Enum == 30 then Stk[Inst[2]]=Const[Inst[3]];else Stk[Inst[2]]=Stk[Inst[3]][Stk[Inst[5]]];end; elseif Enum <= 33 then if Enum == 32 then local A=Inst[2];local Args={};local Edx=0;local Limit=A+Inst[3]-1;for Idx=A+1,Limit do Edx=Edx+1;Args[Edx]=Stk[Idx];end;local Results={Stk[A](Unpack(Args,1,Limit-A))};local Limit=A+Inst[5]-2;Edx=0;for Idx=A,Limit do Edx=Edx+1;Stk[Idx]=Results[Edx];end;Top=Limit;else Stk[Inst[2]]=Stk[Inst[3]][Stk[Inst[5]]];end; elseif Enum == 34 then if(Stk[Inst[2]]~=Stk[Inst[5]])then InstrPoint=InstrPoint+1;else InstrPoint=InstrPoint+Inst[3];end;else local A=Inst[2];local Args={};local Edx=0;local Limit=A+Inst[3]-1;for Idx=A+1,Limit do Edx=Edx+1;Args[Edx]=Stk[Idx];end;local Results={Stk[A](Unpack(Args,1,Limit-A))};local Limit=A+Inst[5]-2;Edx=0;for Idx=A,Limit do Edx=Edx+1;Stk[Idx]=Results[Edx];end;Top=Limit;end; elseif Enum <= 38 then if Enum <= 36 then if(Stk[Inst[2]]<Stk[Inst[5]])then InstrPoint=InstrPoint+1;else InstrPoint=InstrPoint+Inst[3];end; elseif Enum > 37 then do return end;else Stk[Inst[2]]=Stk[Inst[3]]/Const[Inst[5]];end; elseif Enum <= 40 then if Enum > 39 then Stk[Inst[2]]=Stk[Inst[3]];else Top=Inst[2];end; elseif Enum == 41 then local A=Inst[2];local Step=Stk[A+2];local Index=Stk[A]+Step;Stk[A]=Index;if Step>0 then if Index<=Stk[A+1] then InstrPoint=InstrPoint+Inst[3];Stk[A+3]=Index;end;elseif Index>=Stk[A+1] then InstrPoint=InstrPoint+Inst[3];Stk[A+3]=Index;end;else local A=Inst[2];Stk[A]=Stk[A]-Stk[A+2];InstrPoint=InstrPoint+Inst[3];end; elseif Enum <= 49 then if Enum <= 45 then if Enum <= 43 then do return end; elseif Enum > 44 then Stk[Inst[2]][Stk[Inst[3]]]=Stk[Inst[5]];else Stk[Inst[2]]=Stk[Inst[3]];end; elseif Enum <= 47 then if Enum > 46 then Stk[Inst[2]]=Stk[Inst[3]]-Stk[Inst[5]];else Stk[Inst[2]]=Stk[Inst[3]]+Stk[Inst[5]];end; elseif Enum == 48 then Stk[Inst[2]]=Env[Const[Inst[3]]];else Top=Inst[2];end; elseif Enum <= 53 then if Enum <= 51 then if Enum > 50 then local A=Inst[2];local Args={};local Edx=0;local Limit=A+Inst[3]-1;for Idx=A+1,Limit do Edx=Edx+1;Args[Edx]=Stk[Idx];end;Stk[A](Unpack(Args,1,Limit-A));Top=A;else InstrPoint=InstrPoint+Inst[3];end; elseif Enum > 52 then Stk[Inst[2]]=Stk[Inst[3]]*Const[Inst[5]];else Stk[Inst[2]]=Const[Inst[3]];end; elseif Enum <= 55 then if Enum == 54 then Stk[Inst[2]]=Stk[Inst[3]]%Const[Inst[5]];else if(Const[Inst[2]]>=Stk[Inst[5]])then InstrPoint=InstrPoint+1;else InstrPoint=InstrPoint+Inst[3];end;end; elseif Enum > 56 then Stk[Inst[2]]=#Stk[Inst[3]];else Stk[Inst[2]]=Stk[Inst[3]]-Const[Inst[5]];end;
			InstrPoint	= InstrPoint + 1;
		end;
    end;
end;	
return Wrap(Deserialize(), {}, GetFEnv())();