{  
   Copyright (C) 2006 The devFlowcharter project.
   The initial author of this file is Michal Domagala.

   This program is free software; you can redistribute it and/or
   modify it under the terms of the GNU General Public License
   as published by the Free Software Foundation; either version 2
   of the License, or (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
}



unit RepeatUntil_Block;

interface

uses
   Controls, Messages, Forms, StdCtrls, Graphics, Classes, SysUtils, Base_Block,
   CommonInterfaces, Types;

type

   TRepeatUntilBlock = class(TGroupBlock)
      public
         constructor Create(const ABranch: TBranch; const ALeft, ATop, AWidth, AHeight, b_hook, p1X, p1Y: integer; const AId: integer = ID_INVALID); overload;
         constructor Create(const ABranch: TBranch; const ASource: TRepeatUntilBlock); overload;
         constructor Create(const ABranch: TBranch); overload;
         procedure ChangeColor(const AColor: TColor); override;
      protected
         procedure Paint; override;
         procedure SetWidth(const min_x: integer); override;
         function GetDiamondPoint: TPoint; override;
   end;

implementation

uses
   ApplicationCommon, Windows, StrUtils, CommonTypes;

constructor TRepeatUntilBlock.Create(const ABranch: TBranch; const ALeft, ATop, AWidth, AHeight, b_hook, p1X, p1Y: integer; const AId: integer = ID_INVALID);
begin

   FType := blRepeat;

   inherited Create(ABranch, ALeft, ATop, AWidth, AHeight, Point(p1X, p1Y), AId);

   FInitParms.Width := 240;
   FInitParms.Height := 111;
   FInitParms.BottomHook := 120;
   FInitParms.BranchPoint.X := 120;
   FInitParms.BottomPoint.X := 229;
   FInitParms.P2X := 0;
   FInitParms.HeightAffix := 82;

   BottomPoint.X := Width - 11;
   BottomPoint.Y := Height - 50;
   TopHook.Y := 0;
   BottomHook := b_hook;
   TopHook.X := p1X;
   Constraints.MinWidth := FInitParms.Width;
   Constraints.MinHeight := FInitParms.Height;
   FStatement.Color := GSettings.DiamondColor;
   FStatement.Alignment := taCenter;
   PutTextControls;

end;

constructor TRepeatUntilBlock.Create(const ABranch: TBranch; const ASource: TRepeatUntilBlock);
begin

   Create(ABranch,
          ASource.Left,
          ASource.Top,
          ASource.Width,
          ASource.Height,
          ASource.BottomHook,
          ASource.Branch.Hook.X,
          ASource.Branch.Hook.Y);

   inherited Create(ASource);

end;

constructor TRepeatUntilBlock.Create(const ABranch: TBranch);
begin
   Create(ABranch, 0, 0, 240, 111, 120, 120, 29);
end;

procedure TRepeatUntilBlock.Paint;
begin
   inherited;
   if Expanded then
   begin
      IPoint.X := BottomHook + 40;
      IPoint.Y := Height - 25;
      BottomPoint.Y := Height - 50;
      PutTextControls;

      TInfra.DrawArrowLine(Canvas, Point(Branch.Hook.X, TopHook.Y), Branch.Hook);
      TInfra.DrawArrowLine(Canvas, Point(5, Height-51), Point(5, 0), apMiddle);
      TInfra.DrawArrowLine(Canvas, Point(BottomPoint.X, Height-51), Point(BottomPoint.X, Height-1));
      with Canvas do
      begin
         Brush.Style := bsClear;
         TextOut(BottomHook-TextWidth(FFalseLabel)-60, Height-72, FFalseLabel);
         TextOut(BottomHook+60, Height-72, FTrueLabel);
         MoveTo(BottomPoint.X, Height-51);
         LineTo(BottomHook+60, Height-51);
         MoveTo(BottomHook-60, Height-51);
         LineTo(5, Height-51);
         MoveTo(5, 0);
         LineTo(Branch.Hook.X, TopHook.Y);
      end;
   end;
   DrawI;
end;

procedure TRepeatUntilBlock.SetWidth(const min_x: integer);
begin
   if min_x < BottomHook + 121 then
      Width := BottomHook + 121
   else
      Width := min_x;
   BottomPoint.X := Width - 11;
end;

function TRepeatUntilBlock.GetDiamondPoint: TPoint;
begin
   result := Point(BottomHook, Height-81);
end;

procedure TRepeatUntilBlock.ChangeColor(const AColor: TColor);
begin
   inherited ChangeColor(AColor);
   if GSettings.DiamondColor = GSettings.DesktopColor then
      FStatement.Color := AColor
   else
      FStatement.Color := GSettings.DiamondColor;
end;

end.