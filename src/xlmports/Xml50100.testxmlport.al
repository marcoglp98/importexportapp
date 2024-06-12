xmlport 50100 testxmlport
{
    Caption = 'testxmlport';
    Format = Xml;
    Direction = Export;
    UseRequestPage = false;


    schema
    {
        textelement(RootNodeName)
        {
            tableelement(exceltable; exceltable)
            {
                fieldelement(No; exceltable."No.")
                {
                }
                fieldelement(Name; exceltable.Name)
                {
                }
                fieldelement(Surname; exceltable.Surname)
                {
                }
                fieldelement(Age; exceltable.Age)
                {
                }
            }
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
}
