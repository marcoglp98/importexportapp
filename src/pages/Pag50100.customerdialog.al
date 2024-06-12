page 50100 customerdialog
{
    ApplicationArea = All;
    Caption = 'Find Customer';
    PageType = StandardDialog;
    SourceTable = Customer;

    layout
    {
        area(content)
        {
            field(MyInputText; MyInputText)
            {
                Caption = 'Insert name';
                NotBlank = true;
            }
        }
    }

    actions
    {
    }

    procedure ExecuteOKCode();
    var

        customertable: Record Customer;
        SalesHeader: Record "Sales Header";
        //foundmessage: Label 'The customer %1 exist and his No. is %2, do you want to create a sales order?';
        notfoundmessage: Label 'The customer %1 does not exist';
        ConfirmCnf: Label 'The customer %1 exists and his No. is %2, do you want to create a sales order?';
    begin


        customertable.SetFilter(Name, MyInputText);

        if customertable.FindSet() then begin

            // if Confirm('The customer ' + customertable.Name + ' exists and his No. is ' + customertable."No." + ', do you want to create a sales order?', true) then
            if Confirm(ConfirmCnf, true, customertable.Name, customertable."No.") then
                SalesHeader."Document Type" := SalesHeader."Document Type"::Order;
            SalesHeader."Sell-to Customer No." := customertable."No.";
            SalesHeader."Sell-to Customer Name" := customertable.Name;
            SalesHeader.Insert(true);

            //Message(foundmessage, customertable.Name, customertable."No.");
        end else
            Message(notfoundmessage, MyInputText);

    end;

    var
        MyInputText: text;
}