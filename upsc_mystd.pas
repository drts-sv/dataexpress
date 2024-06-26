{-------------------------------------------------------------------------------

    Copyright 2015-2024 Pavel Duborkin ( mydataexpress@mail.ru )

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

    Based on the original uPSC_Std.pas file of the RemObject Pascal Script
    component.
-------------------------------------------------------------------------------}

{ Compiletime TObject, TPersistent and TComponent definitions }
unit uPSC_MyStd;
interface
uses
  uPSCompiler, uPSUtils;

{
  Will register files from:
    System
    Classes (Only TComponent and TPersistent)

}

procedure SIRegister_Std_TypesAndConsts(Cl: TPSPascalCompiler);
procedure SIRegisterTObject(CL: TPSPascalCompiler);
procedure SIRegisterTPersistent(Cl: TPSPascalCompiler);
procedure SIRegisterTComponent(Cl: TPSPascalCompiler; IsWeb: Boolean);

procedure SIRegister_Std(Cl: TPSPascalCompiler);
procedure SIRegister_StdWeb(Cl: TPSPascalCompiler);

implementation

procedure SIRegisterTObject(CL: TPSPascalCompiler);
begin
  with Cl.AddClassN(nil, 'TObject') do
  begin
    RegisterMethod('constructor Create');
    RegisterMethod('procedure Free');
    RegisterProperty('ClassName', 'String', iptR);
  end;
end;

procedure SIRegisterTPersistent(Cl: TPSPascalCompiler);
begin
  with Cl.AddClassN(cl.FindClass('TObject'), 'TPersistent') do
  begin
    RegisterMethod('procedure Assign(Source: TPersistent)');
  end;
end;

procedure SIRegisterTComponent(Cl: TPSPascalCompiler; IsWeb: Boolean);
begin
  with Cl.AddClassN(cl.FindClass('TPersistent'), 'TComponent') do
  begin
    RegisterMethod('function FindComponent(AName: string): TComponent;');
    RegisterMethod('constructor Create(AOwner: TComponent); virtual;');

    RegisterProperty('Owner', 'TComponent', iptR);
    RegisterProperty('Components', 'TComponent Integer', iptr);
    RegisterProperty('ComponentCount', 'Integer', iptr);
    RegisterProperty('Name', 'string', iptrw);
    if not IsWeb then
    begin
      RegisterProperty('ComponentIndex', 'Integer', iptrw);
      RegisterProperty('Tag', 'LongInt', iptrw);
    end;
  end;
end;

procedure SIRegister_Std_TypesAndConsts(Cl: TPSPascalCompiler);
begin
  //Cl.AddTypeS('TComponentStateE', '(csLoading, csReading, csWriting, csDestroying, csDesigning, csAncestor, csUpdating, csFixups, csFreeNotification, csInline, csDesignInstance)');
  //cl.AddTypeS('TComponentState', 'set of TComponentStateE');
  Cl.AddTypeS('TRect', 'record Left, Top, Right, Bottom: Integer; end;');
end;

procedure SIRegister_Std(Cl: TPSPascalCompiler);
begin
  SIRegister_Std_TypesAndConsts(Cl);
  SIRegisterTObject(CL);
  SIRegisterTPersistent(Cl);
  SIRegisterTComponent(Cl, False);
end;

procedure SIRegister_StdWeb(Cl: TPSPascalCompiler);
begin
  SIRegister_Std_TypesAndConsts(Cl);
  SIRegisterTObject(CL);
  SIRegisterTPersistent(Cl);
  SIRegisterTComponent(Cl, True);
end;

// PS_MINIVCL changes by Martijn Laan (mlaan at wintax _dot_ nl)


End.
