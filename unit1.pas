unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, IBConnection, sqldb, db, SdfData, FileUtil, Forms,
  Controls, Graphics, Dialogs, DBGrids, DbCtrls, StdCtrls, ExtCtrls, Buttons,
  ComCtrls, Grids, LCLType;

type

  { TForm1 }

  TForm1 = class(TForm)
    BitBtn1: TBitBtn;
    Button1: TButton;
    Button2: TButton;
    CheckBox1: TCheckBox;
    Datasource1: TDatasource;
    Datasource2: TDatasource;
    DBComboBox1: TDBComboBox;
    DBGrid1: TDBGrid;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    IBConnection1: TIBConnection;
    ImageList1: TImageList;
    Label1: TLabel;
    Label2: TLabel;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    LabeledEdit3: TLabeledEdit;
    LabeledEdit4: TLabeledEdit;
    LabeledEdit5: TLabeledEdit;
    Memo1: TMemo;
    OpenDialog1: TOpenDialog;
    SQLQuery1: TSQLQuery;
    SQLQuery2: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    SQLTransaction2: TSQLTransaction;
    StringGrid1: TStringGrid;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    procedure BitBtn1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure DBGrid1SelectEditor(Sender: TObject; Column: TColumn;
      var Editor: TWinControl);
    procedure Memo1Change(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
  LabeledEdit1.Text:='localhost';
  if OpenDialog1.Execute then LabeledEdit5.Text:=OpenDialog1.FileName;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin

   SQLQuery1.Active:=false;
   SQLQuery1.SQL.Text:='create or alter procedure GET_CLIENT_JOB (CLID varchar(10), CLIC varchar(15), CLGD integer) returns (WRK varchar(150), REQ varchar(500), WCT varchar(10), ESAL integer) as begin for select JOB.JOB_TITLE, substring(job.job_requirement from 1 for 500), job.job_country, employee.salary from JOB, EMPLOYEE where EMPLOYEE.JOB_CODE = JOB.JOB_CODE and EMPLOYEE.EMP_NO = :CLID and JOB.JOB_COUNTRY = :CLIC and JOB.JOB_GRADE = :CLGD into :WRK, :req, :WCT, :ESAL do suspend; end;';
   SQLQuery1.ExecSQL;
   SQLTransaction1.Commit;

end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  if not CheckBox1.Checked
  then begin
      DBGrid1.AutoFillColumns:=True;

  end else begin
      DBGrid1.AutoFillColumns:=False;
      DBGrid1.AutoSizeColumns;
      //DBGrid1.AutoAdjustColumns;
      //DBGrid1.Options[dgAutoSizeColumns]:=True;
      SQLQuery1.Active:=false;
      SQLQuery1.Active:=true;
  end;
end;

procedure TForm1.DBGrid1CellClick(Column: TColumn);
var empid, empct, empgd, val,fnm:string; i: integer; fdata:tfield;
begin


  {
  SQLQuery2.Active:=false;
  SQLQuery2.SQL.Text:='select EMPLOYEE.EMP_NO from EMPLOYEE where EMPLOYEE.first_name = '''+Datasource1.DataSet.Fields[0].value+''';';
  SQLTransaction2.Active:=true;
  SQLQuery2.Active:=true;
  }

  StringGrid1.Clean;

  empid:=DBGrid1.DataSource.DataSet.Fields[0].Value;
  empct:=DBGrid1.DataSource.DataSet.Fields[1].Value;
  empgd:=DBGrid1.DataSource.DataSet.Fields[2].Value;

  SQLQuery2.Active:=false;
  SQLQuery2.SQL.Text:='SELECT wrk, wct, esal, req FROM get_client_job('''+empid+''', '''+empct+''', '+empgd+')';
  SQLTransaction2.Active:=true;
  SQLQuery2.Active:=true;

  //dbgrid2.DataSource:='';
  i:=0;
  StringGrid1.RowCount:=DataSource2.DataSet.Fields.Count-1;
  while (i < DataSource2.DataSet.Fields.Count) do
  begin
       fdata:=DataSource2.DataSet.Fields[i];
       //fnm:=DataSource2.DataSet.Fields[i].FieldName;
       case DataSource2.DataSet.Fields[i].FieldName of
       'WRK': fnm:='Должность:';
       'WCT': fnm:='Местоположение офиса:';
       'ESAL': fnm:='Зарплата соотрудника:';
       'REQ': fnm:='Условия работы';
       end;


       if DataSource2.DataSet.Fields[i].Value=null then val:='' else val:=DataSource2.DataSet.Fields[i].Value;
       if (i=3) then
       begin
       Memo1.text:=val;
       label2.Caption:=fnm;
       end else begin
       StringGrid1.Cells[0,i]:=fnm;
       StringGrid1.Cells[1,i]:=val;
       end;
       Inc(i); //i:=i+1;
  end;
end;

procedure TForm1.DBGrid1SelectEditor(Sender: TObject; Column: TColumn;
  var Editor: TWinControl);
begin

end;

procedure TForm1.Memo1Change(Sender: TObject);
begin

end;

procedure TForm1.ToolButton1Click(Sender: TObject);
begin
   SQLQuery1.Active:=false;
        SQLQuery1.SQL.Text:='select EMPLOYEE.EMP_NO, EMPLOYEE.JOB_COUNTRY, EMPLOYEE.JOB_GRADE,'+
       ' EMPLOYEE.FIRST_NAME as "Имя", EMPLOYEE.LAST_NAME as "Фамилия", EMPLOYEE.HIRE_DATE as "Дата найма",'+
       ' phone_list.location as "Регион", EMPLOYEE.PHONE_EXT as "Региональный код", phone_list.phone_no as "Телефон"'+
       ' from EMPLOYEE, DEPARTMENT, JOB, phone_list, COUNTRY'+
       ' where EMPLOYEE.DEPT_NO = DEPARTMENT.DEPT_NO and'+
       ' EMPLOYEE.JOB_CODE = JOB.JOB_CODE and'+
       ' EMPLOYEE.JOB_GRADE = JOB.JOB_GRADE and'+
       ' EMPLOYEE.JOB_COUNTRY = JOB.JOB_COUNTRY and'+
       ' employee.emp_no = phone_list.emp_no and'+
       ' EMPLOYEE.JOB_COUNTRY = COUNTRY.COUNTRY'+
       ' order by EMPLOYEE.EMP_NO;';
   {
   SQLQuery1.SQL.Text:='select EMPLOYEE.FIRST_NAME as "Имя", EMPLOYEE.LAST_NAME as "Фамилия", EMPLOYEE.HIRE_DATE as "Дата найма", DEPARTMENT.DEPARTMENT as "Депртамент",'+
       ' JOB.JOB_TITLE as "Должность", EMPLOYEE.JOB_GRADE as "Квалификация", EMPLOYEE.JOB_COUNTRY as "Страна обучения", phone_list.location as "Регион", EMPLOYEE.PHONE_EXT as "Региональный код", phone_list.phone_no as "Телефон", EMPLOYEE.SALARY as "Зарплата", COUNTRY.CURRENCY as "Валюта"'+
       ' from EMPLOYEE, DEPARTMENT, JOB, phone_list, COUNTRY'+
       ' where EMPLOYEE.DEPT_NO = DEPARTMENT.DEPT_NO and'+
       ' EMPLOYEE.JOB_CODE = JOB.JOB_CODE and'+
       ' EMPLOYEE.JOB_GRADE = JOB.JOB_GRADE and'+
       ' EMPLOYEE.JOB_COUNTRY = JOB.JOB_COUNTRY and'+
       ' employee.emp_no = phone_list.emp_no and'+
       ' EMPLOYEE.JOB_COUNTRY = COUNTRY.COUNTRY'+
       ' order by EMPLOYEE.EMP_NO;';
       }
   SQLTransaction1.Active:=true;
   SQLQuery1.Active:=true;
   GroupBox2.Caption:='Сейчас вы просматривает сводку по соотрудникам';
   DBGrid1.DataSource.DataSet.Fields[0].Visible:=false;
   DBGrid1.DataSource.DataSet.Fields[1].Visible:=false;
   DBGrid1.DataSource.DataSet.Fields[2].Visible:=false;

end;

procedure TForm1.ToolButton2Click(Sender: TObject);
begin
   SQLQuery1.Active:=false;
   SQLQuery1.SQL.Text:='select EMPLOYEE.FIRST_NAME as "Имя", EMPLOYEE.LAST_NAME as "Фамилия", proj_dept_budget.projected_budget as "Бюджет проекта", proj_dept_budget.fiscal_year as "Год отчётности", department.department as "Департамент", PROJECT.PROJ_NAME as "Название проекта", substring(PROJECT.PROJ_DESC from 1 for 500) as "Описание проекта"'+
' from EMPLOYEE, EMPLOYEE_PROJECT, PROJECT, proj_dept_budget, department'+
' where EMPLOYEE.EMP_NO = EMPLOYEE_PROJECT.EMP_NO and'+
' EMPLOYEE_PROJECT.PROJ_ID = PROJECT.PROJ_ID and'+
' employee_project.proj_id = proj_dept_budget.proj_id and'+
' department.dept_no = proj_dept_budget.dept_no'+
' order by EMPLOYEE.EMP_NO;';
   SQLTransaction1.Active:=true;
   SQLQuery1.Active:=true;
   GroupBox2.Caption:='Сейчас вы просматривает сводку по проектам предприятия';
end;

procedure TForm1.ToolButton3Click(Sender: TObject);
begin
  SQLQuery1.Active:=false;
  SQLQuery1.SQL.Text:='select CUSTOMER.CONTACT_FIRST as "Заказчик", CUSTOMER.CONTACT_LAST as "Заместитель", CUSTOMER.CUSTOMER as "Название предприятия", CUSTOMER.ADDRESS_LINE1 as "Адрес", CUSTOMER.PHONE_NO as "Телефон",'+
' CUSTOMER.CITY as "Город", CUSTOMER.COUNTRY as "Страна", SALES.ITEM_TYPE as "Тип товара", SALES.ORDER_STATUS as "Статус доставки", SALES.SALES_REP as "Рейтинг продаж", SALES.TOTAL_VALUE as "Доходы", COUNTRY.CURRENCY as "Валюта"'+
' from CUSTOMER, SALES, COUNTRY'+
' where CUSTOMER.CUST_NO = SALES.CUST_NO and'+
' CUSTOMER.COUNTRY = COUNTRY.COUNTRY'+
' order by CUSTOMER.CUST_NO;';
  SQLTransaction1.Active:=true;
  SQLQuery1.Active:=true;
  GroupBox2.Caption:='Сейчас вы просматривает сводку по финансовым опреациям';
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
  if (IBConnection1.Connected) then
  begin
    IBConnection1.Connected:=False;
    LabeledEdit1.Enabled:=True;
    LabeledEdit2.Enabled:=True;
    LabeledEdit3.Enabled:=True;
    LabeledEdit4.Enabled:=True;
    LabeledEdit5.Enabled:=True;
    Button1.Enabled:=True;
    BitBtn1.Kind:=bkRetry;
    BitBtn1.Caption:='Подключиться';
    ToolBar1.Enabled:=False;
    StringGrid1.Clean;
    Memo1.Clear;
    label2.Caption:='';
  end else begin
  try
    IBConnection1.DatabaseName:=LabeledEdit5.Text;
    IBConnection1.HostName:=LabeledEdit1.Text+'/'+LabeledEdit2.Text;
    IBConnection1.UserName:=LabeledEdit3.Text;
    IBConnection1.Password:=LabeledEdit4.Text;

    IBConnection1.Connected:=TRue;
    SQLTransaction1.Active:=True;
    SQLQuery1.Active:=False;

    ToolBar1.Enabled:=True;
    LabeledEdit1.Enabled:=False;
    LabeledEdit2.Enabled:=False;
    LabeledEdit3.Enabled:=False;
    LabeledEdit4.Enabled:=False;
    LabeledEdit5.Enabled:=False;
    Button1.Enabled:=False;
    BitBtn1.Kind:=bkAbort;
    BitBtn1.Caption:='Отключиться';

    Application.MessageBox('Выберите типа отчёта, кторый хотите прочитать.'+#13+'Используйте нижнюю панель, для перключения между отчётами.', 'Соединение выполнено.', MB_ICONEXCLAMATION+MB_OK);
  except
    Application.MessageBox('Проблемы с соединением!'+#13+'Убедитесь что адрес и порт сервера, а так же путь к БД верны.', 'Соединение НЕ выполнено.', MB_ICONERROR+MB_OK);
  end;
  end;
end;

end.

