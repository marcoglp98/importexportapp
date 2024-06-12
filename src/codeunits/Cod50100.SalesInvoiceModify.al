codeunit 50100 SalesInvoiceModify
{
    Permissions = tabledata "Sales Invoice Header" = rimd;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterFinalizePostingOnBeforeCommit', '', true, true)]
    // local procedure OnRunOnBeforeFinalizePosting_SalesPost(var SalesInvoiceHeader: Record "Sales Invoice Header")
    // begin
    //     SalesInvoiceHeader.Testdate := WorkDate();
    //     // Salesinvoiceheader.Modify();
    // end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', true, true)]
    local procedure OnAfterPostSalesDoc_SalesPost(SalesInvHdrNo: Code[20])
    var
        Salesinvoiceheader: Record "Sales Invoice Header";
    begin
        Salesinvoiceheader.get(SalesInvHdrNo);
        SalesInvoiceHeader.Testdate := WorkDate();
        Salesinvoiceheader.Modify();
    end;

}
