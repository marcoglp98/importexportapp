page 50101 excellist
{
    ApplicationArea = All;
    Caption = 'excellist';
    UsageCategory = Lists;
    PageType = List;
    SourceTable = exceltable;
    CardPageId = excelcard;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                Caption = 'General';

                field("No."; Rec."No.") { }
                field(Name; Rec.Name) { }
                field(Surname; Rec.Surname) { }
                field(Age; Rec.Age) { }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(exporttoexcel)
            {
                ApplicationArea = All;
                Caption = 'Export to Excel';
                Image = Excel;

                trigger OnAction()
                var
                    exceltable: Record exceltable;
                begin
                    importexport.exportexcel();
                end;
            }

            action(importexcel)
            {
                ApplicationArea = All;
                Caption = 'Import from Excel';
                Image = ImportExcel;

                trigger OnAction()
                var
                    exceltable: Record exceltable;
                begin
                    importexport.readexcelsheet();
                    importexport.importexceldata();
                end;
            }

            action(exportcsv)
            {
                ApplicationArea = All;
                Caption = 'Export to CSV file';
                Image = Export;

                trigger OnAction()
                var
                    exceltable: Record exceltable;
                begin
                    importexport.exporttocsv();
                end;
            }

            action(importcsv)
            {
                ApplicationArea = All;
                Caption = 'Import from CSV file';
                Image = Import;

                trigger OnAction()
                var
                    exceltable: Record exceltable;
                begin
                    importexport.readcsvsheet();
                    importexport.importcsvdata();
                end;
            }

            action(exportjson)
            {
                ApplicationArea = All;
                Caption = 'Export to JSON file';
                Image = Export;

                trigger OnAction()
                begin
                    importexport.exporttojson();
                end;
            }

            action(exportxml)
            {
                ApplicationArea = All;
                Caption = 'Export to XML file';
                Image = Export;

                trigger OnAction()
                begin
                    // Xmlport.run(50100, true, false);
                    importexport.exporttoxml();
                end;
            }

        }
    }

    var
        importexport: Codeunit importexport;

}
