pageextension 50101 SalesInvoiceHeaderExt extends "Posted Sales Invoice"
{
    layout
    {
        addafter("No.")
        {

            field("Test Date"; Rec.Testdate)
            {
                ApplicationArea = all;
                Caption = 'Test Date';
            }
        }

    }
}
