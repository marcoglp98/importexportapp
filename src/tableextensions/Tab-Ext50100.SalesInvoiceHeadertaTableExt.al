tableextension 50100 SalesInvoiceHeadertaTableExt extends "Sales Invoice Header"
{

    fields
    {
        field(50100; Testdate; Date)
        {
            Caption = 'Test Date';
            DataClassification = ToBeClassified;
        }
    }
}
