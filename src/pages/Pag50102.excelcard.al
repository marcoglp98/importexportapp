page 50102 excelcard
{
    ApplicationArea = All;
    Caption = 'excelcard';
    PageType = Card;
    SourceTable = exceltable;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.") { }
                field(Name; Rec.Name) { }
                field(Surname; Rec.Surname) { }
                field(Age; Rec.Age) { }
            }
        }
    }
}
