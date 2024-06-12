codeunit 50101 importexport
{
    var
        FileName: Text[100];
        tempblob: Codeunit "Temp Blob";
        exceltable: Record exceltable;


    ///////////ESPORTAZIONE EXCEL//////////////////////////////////

    procedure exportexcel()
    var
        tempcsvbuffer: Record "Excel Buffer" temporary;
        exceltablelelbl: Label 'Excel Table';
        excelfilename: Label 'exceltablele_%1_%2';

    begin
        tempcsvbuffer.Reset();
        tempcsvbuffer.DeleteAll();
        tempcsvbuffer.NewRow();
        tempcsvbuffer.AddColumn(exceltable.FieldCaption("No."), false, '', false, false, false, '', tempcsvbuffer."Cell Type"::Text);
        tempcsvbuffer.AddColumn(exceltable.FieldCaption("Name"), false, '', false, false, false, '', tempcsvbuffer."Cell Type"::Text);
        tempcsvbuffer.AddColumn(exceltable.FieldCaption("Surname"), false, '', false, false, false, '', tempcsvbuffer."Cell Type"::Text);
        tempcsvbuffer.AddColumn(exceltable.FieldCaption("Age"), false, '', false, false, false, '', tempcsvbuffer."Cell Type"::Text);
        if exceltable.FindSet() then
            repeat
                tempcsvbuffer.NewRow();
                tempcsvbuffer.AddColumn(exceltable."No.", false, '', false, false, false, '', tempcsvbuffer."Cell Type"::Text);
                tempcsvbuffer.AddColumn(exceltable.Name, false, '', false, false, false, '', tempcsvbuffer."Cell Type"::Text);
                tempcsvbuffer.AddColumn(exceltable.Surname, false, '', false, false, false, '', tempcsvbuffer."Cell Type"::Text);
                tempcsvbuffer.AddColumn(exceltable.Age, false, '', false, false, false, '', tempcsvbuffer."Cell Type"::Text);
            until exceltable.Next() = 0;
        tempcsvbuffer.CreateNewBook(exceltablelelbl);
        tempcsvbuffer.WriteSheet(exceltablelelbl, CompanyName, UserId);
        tempcsvbuffer.CloseBook();
        tempcsvbuffer.SetFriendlyFilename(StrSubstNo(excelfilename, CurrentDateTime, UserId));
        tempcsvbuffer.OpenExcel();
    end;
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////


    ////////////////////IMPORTAZIONE EXCEL/////////////////////////////////////////////////////////////////////////////

    var
        BatchName: Code[10];

        SheetName: Text[100];

        TempExcelBuffer: Record "Excel Buffer" temporary;
        UploadExcelMsg: Label 'Please Choose the Excel file.';
        NoFileFoundMsg: Label 'No Excel file found!';
        BatchISBlankMsg: Label 'Batch name is blank';
        ExcelImportSucess: Label 'Excel is successfully imported.';

    procedure readexcelsheet()
    var

        filemgt: Codeunit "File Management";
        istream: InStream;
        fromfile: Text[200];
    begin

        UploadIntoStream(UploadExcelMsg, '', '', fromfile, istream);
        if fromfile <> '' then begin
            FileName := filemgt.GetFileName(fromfile);
            SheetName := TempExcelBuffer.SelectSheetsNameStream(istream);

        end else
            Error(NoFileFoundMsg);
        TempExcelBuffer.Reset();
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.OpenBookStream(istream, SheetName);
        TempExcelBuffer.ReadSheet();
    end;

    procedure importexceldata()
    var

        rowno: Integer;
        colno: Integer;
        lineno: Integer;
        maxrowno: Integer;
    begin
        rowno := 0;
        colno := 0;
        lineno := 0;
        maxrowno := 0;
        exceltable.Reset();
        exceltable.DeleteAll();
        TempExcelBuffer.Reset();
        if TempExcelBuffer.FindLast() then begin
            maxrowno := TempExcelBuffer."Row No.";
        end;
        for rowno := 2 to maxrowno do begin

            exceltable.Init();

            Evaluate(exceltable."No.", getvalueatcell(rowno, 1));
            Evaluate(exceltable.Name, getvalueatcell(rowno, 2));
            Evaluate(exceltable.Surname, getvalueatcell(rowno, 3));
            Evaluate(exceltable.Age, getvalueatcell(rowno, 4));
            exceltable.Insert();


        end;
        Message(ExcelImportSucess);
    end;

    procedure getvalueatcell(rowno: Integer; colno: Integer): Text
    begin
        TempExcelBuffer.Reset();
        if TempExcelBuffer.get(rowno, colno) then
            exit(TempExcelBuffer."Cell Value as Text")
        else
            exit('');
    end;

    ///////////////////////////////////////////////////////////////////////////////////////



    /////////////////////////////////ESPORTAZIONE CSV//////////////////////////////////////

    procedure exporttocsv()
    var

        ins: InStream;
        outs: OutStream;
        filename: Text;
        textbuilder: TextBuilder;


    begin
        filename := 'Testfile_' + UserId + '_' + Format(CurrentDateTime) + '.csv';
        textbuilder.AppendLine('No.' + ';' + 'Name' + ';' + 'Surname' + ';' + 'Age' + ';;');
        if exceltable.FindSet() then
            repeat
                textbuilder.AppendLine(Format(exceltable."No.") + ';' + Format(exceltable.Name) + ';' + Format(exceltable.Surname) + ';' + Format(exceltable.Age) + ';;');

            until exceltable.Next() = 0;
        tempblob.CreateOutStream(outs);
        outs.Write(textbuilder.ToText());
        tempblob.CreateInStream(ins);
        DownloadFromStream(ins, '', '', '', filename);
    end;
    //////////////////////////////////////////////////////////////////////////////////////////////////////


    //////////////////////////IMPORTAZIONE CSV////////////////////////////////////////////////////////////
    var
        csvbuffer: Record "CSV Buffer" temporary;
        uploadmsg: Label 'Choose csv file';
        nofilemsg: Label 'No csv file found!';
        transisblankmsg: Label 'transaction name is blank';
        csvimportsuccess: Label 'csv imported succesfully';
        transname: Code[10];

    procedure readcsvsheet()
    var

        filemgt: Codeunit "File Management";
        istream: InStream;
        fromfile: Text[100];

    begin

        UploadIntoStream(uploadmsg, '', '', fromfile, istream);
        if fromfile <> '' then begin
            FileName := filemgt.GetFileName(fromfile);


        end else
            Error(nofilemsg);
        csvbuffer.Reset();
        csvbuffer.DeleteAll();
        csvbuffer.LoadDataFromStream(istream, ';');
        csvbuffer.GetNumberOfLines();
    end;

    procedure importcsvdata()
    var

        rowno: Integer;
        colno: Integer;
        lineno: Integer;
        maxrowno: Integer;
    begin
        rowno := 0;
        colno := 0;
        lineno := 0;
        maxrowno := 0;
        exceltable.Reset();
        csvbuffer.Reset();
        if csvbuffer.FindLast() then begin
            maxrowno := csvbuffer."Line No.";
        end;
        for rowno := 2 to maxrowno do begin
            exceltable.init();
            Evaluate(exceltable."No.", getvalueatcell(rowno, 1));
            Evaluate(exceltable.Name, getvalueatcell(rowno, 2));
            Evaluate(exceltable.Surname, getvalueatcell(rowno, 3));
            Evaluate(exceltable.Age, getvalueatcell(rowno, 4));
            exceltable.Insert();
        end;
        Message(csvimportsuccess);
    end;

    ////////////////////////////////////////////////////////////////////////////////////////////////////


    /////////////////////////////////ESPORTAZIONE JSON///////////////////////////////////////

    procedure exporttojson()
    var

        exctablejson: JsonObject;
        exctablearray: JsonArray;
        ins: InStream;
        outs: OutStream;
        exportfilename: Text;


    begin


        exctablejson.Add(exceltable.FieldCaption("No."), exceltable."No.");
        exctablejson.Add(exceltable.FieldCaption(Name), exceltable.Name);
        exctablejson.Add(exceltable.FieldCaption(Surname), exceltable.Surname);
        exctablejson.Add(exceltable.FieldCaption(Age), exceltable.Age);
        exctablearray.add(exctablejson);


        if exceltable.FindSet() then
            repeat
                Clear(exctablejson);
                exctablejson.Add(exceltable.FieldCaption("No."), exceltable."No.");
                exctablejson.Add(exceltable.FieldCaption(Name), exceltable.Name);
                exctablejson.Add(exceltable.FieldCaption(Surname), exceltable.Surname);
                exctablejson.Add(exceltable.FieldCaption(Age), exceltable.Age);
                exctablearray.add(exctablejson);
            until exceltable.Next() = 0;
        exceltable.Reset();
        exceltable.FindSet();
        tempblob.CreateOutStream(outs);
        if exctablearray.WriteTo(outs) then begin
            exportfilename := 'exctable.json';
            tempblob.CreateInStream(ins);
            DownloadFromStream(ins, '', '', '', exportfilename);
        end;

    end;
    /////////////////////////////////////////////////////////////////////////////////////////////////


    //////////////////////ESPORTAZIONE XML///////////////////////////////////////////////////////////

    procedure exporttoxml()
    var
        xmlroot: XmlElement;
        XmlDoc: XmlDocument;
        XmlDec: XmlDeclaration;
        XmlResult: Text;
        exportfilename: Text;
        ins: InStream;
        outs: OutStream;
        xmlitems: XmlElement;
        xmlElem: XmlElement;
        xmlElem2: XmlElement;
        xmlElem3: XmlElement;
        xmlElem4: XmlElement;


    begin
        //Create the doc
        xmlDoc := xmlDocument.Create();

        //Add the declaration
        xmlDec := xmlDeclaration.Create('1.0', 'utf-8', 'yes');
        xmlDoc.SetDeclaration(xmlDec);

        //Create root node
        xmlroot := xmlElement.Create('exportxml');

        //Add some attributes to the root node
        //xmlElem.SetAttribute('attribute1', 'value1');
        //xmlElem.SetAttribute('attribute2', 'value2');

        //Add DataItems

        repeat
            xmlitems := XmlElement.Create('items');

            //Add a couple of DataItem 
            xmlElem := XmlElement.Create('No.');
            xmlElem2 := XmlElement.Create('Name');
            xmlElem3 := XmlElement.Create('Surname');
            xmlElem4 := XmlElement.Create('Age');


            //Add text to the dataitem
            xmlElem.Add(XmlText.Create(exceltable."No."));
            xmlElem2.Add(XmlText.Create(exceltable.Name));
            xmlElem3.Add(XmlText.Create(exceltable.Surname));
            xmlElem4.Add(XmlText.Create(Format(exceltable.Age)));

            //Write elements to the doc
            xmlitems.Add(xmlElem);
            xmlitems.add(xmlElem2);
            xmlitems.add(xmlElem3);
            xmlitems.add(xmlElem4);
            xmlroot.Add(xmlitems);
        until exceltable.next() = 0;
        XmlDoc.Add(xmlroot);


        tempblob.CreateOutStream(outs);
        if XmlDoc.WriteTo(outs) then begin
            exportfilename := 'exceltable.xml';
            tempblob.CreateInStream(ins);
            DownloadFromStream(ins, '', '', '', exportfilename);
        end;
    end;

}





