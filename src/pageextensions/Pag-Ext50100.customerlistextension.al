pageextension 50100 customerlistextension extends "Customer List"

{
    actions
    {

        AddLast("&Customer")
        {

            action("Sales orders")

            {
                Image = Report;
                trigger OnAction()
                var
                    customerdialog: Page customerdialog;
                begin
                    IF customerdialog.RunModal() = Action::OK then begin
                        customerdialog.ExecuteOKCode();
                    end;
                end;
            }
        }
    }
}