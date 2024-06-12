table 50100 exceltable
{
    Caption = 'exceltable';
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {

        field(1; "No."; Code[50])
        {
            Caption = 'No.';
        }

        field(20; Name; Text[100])
        {
            Caption = 'Name';
        }
        field(30; Surname; Text[100])
        {
            Caption = 'Surname';
        }
        field(40; Age; Integer)
        {
            Caption = 'Age';
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
}
