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


unit Assign_Block;

interface

uses
   Controls, Graphics, Classes, SysUtils, Base_Block, CommonInterfaces, Types;

type

   TAssignBlock = class(TBlock)
      public
         constructor Create(const ABranch: TBranch; const ALeft, ATop, AWidth, AHeight: integer; const AId: integer = ID_INVALID); overload;
         constructor Create(const ABranch: TBranch; const ASource: TAssignBlock); overload;
         constructor Create(const ABranch: TBranch); overload;
         procedure ChangeColor(const AColor: TColor); override;
      protected
         procedure Paint; override;
   end;


implementation

uses
   ApplicationCommon, StrUtils, Forms, CommonTypes;

constructor TAssignBlock.Create(const ABranch: TBranch; const ALeft, ATop, AWidth, AHeight: integer; const AId: integer = ID_INVALID);
begin

   FType := blAssign;

   inherited Create(ABranch, ALeft, ATop, AWidth, AHeight, AId);

   FStatement.SetBounds(0, 0, AWidth, 19);
   FStatement.Anchors := [akRight, akLeft, akTop];
   FStatement.BorderStyle := bsSingle;
   FStatement.Color := GSettings.RectColor;

   BottomPoint.X := AWidth div 2;
   BottomPoint.Y := 19;
   IPoint.X := BottomPoint.X + 30;
   IPoint.Y := 30;
   BottomHook := BottomPoint.X;
   TopHook.X := BottomPoint.X;
   Constraints.MinWidth := 140;
   Constraints.MinHeight := 51;

end;

constructor TAssignBlock.Create(const ABranch: TBranch);
begin
   Create(ABranch, 0, 0, 140, 51);
end;

constructor TAssignBlock.Create(const ABranch: TBranch; const ASource: TAssignBlock);
begin

   Create(ABranch, ASource.Left, ASource.Top, ASource.Width, ASource.Height);
   
   ChangeFontSize(ASource.FStatement.Font.Size);
   ChangeFontStyle(ASource.FStatement.Font.Style);
   Visible := ASource.Visible;
   FStatement.Text := ASource.FStatement.Text;

end;

procedure TAssignBlock.Paint;
begin
   inherited;
   TInfra.DrawArrowLine(Canvas, Point(BottomPoint.X, 19), Point(BottomPoint.X, Height-1));
   DrawI;
end;

procedure TAssignBlock.ChangeColor(const AColor: TColor);
begin
   inherited ChangeColor(AColor);
   if GSettings.RectColor = GSettings.DesktopColor then
      FStatement.Color := AColor
   else
      FStatement.Color := GSettings.RectColor;
end;

end.