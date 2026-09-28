using {poapplication.db as database} from '../db/schema';
//using {Currency} from '@sap/cds/common';
using {poapplication.common as common} from '../db/common';
service CatalogService{
    //Master data which is in the master context.

   // @Capabilities:{
     // InsertRestrictions.Insertable:true,
     // UpdateRestrictions.Updatable:true,
     // DeleteRestrictions.Deletable:true,
     // ReadRestrictions.Readable:false
    //}
    entity EmployeeSrv as projection on database.master.Employees{
      *
    }actions{
      
      action increaseSalary() returns array of EmployeeSrv;
 
        // Instance Bounded Function
      function getTopEmployees() returns array of EmployeeSrv;

    };

    entity ProductSrv as projection on database.master.Products{
      *
    }actions{
      
      action increasePrice() returns array of ProductSrv;
 
        // Instance Bounded Function
      function getTopProducts() returns array of ProductSrv;

    };

    entity BusinessPartnerSrv as projection on database.master.BusinessPartners;

    entity AddressSrv as projection on database.master.Addresses;


    //Transactional data which is in the transaction context.
    entity PurchaseOrderSrv as projection on database.transaction.PurchaseOrders
    {
      *
    } actions {
      //declare instance bounded action
      action discountPrice() returns array of PurchaseOrderSrv;

      //declare instance bounded function
      function largestOrder() returns array of PurchaseOrderSrv;
    };

    entity PurchaseItemSrv as projection on database.transaction.PurchaseItems;
    

    action createEmployee(Currency_code:String(3),
    ID:UUID,
    accountNumber:common.String32,
    bankId:String(16),
    bankName: common.String64,
    email:common.Email,
    gender:common.Gender,
    language:String(2),
    loginName:String(16),
    nameFirst:common.String64,
    nameInitials:common.String64,
    nameLast:common.String64,
    nameMidde:common.String64,
    phoneNumber:common.PhoneNumber,
    salaryAmount:common.AmountT) returns array of EmployeeSrv;

    action createAddress(
      ADDRESS_TYPE:common.String32,
      BUILDING:common.String255,
      CITY:common.String255,
      COUNTRY:common.String255,
      LATITUDE:Decimal,
      LONGITUDE:Decimal,
      NODE_KEY: common.Guid,
      POSTAL_CODE:String(12),
      STREET: common.String255,
      VAL_END: Date,
      VAL_START: Date
    )returns array of AddressSrv;

    action updateEmployee(
      ID:UUID,
      salaryAmount:common.AmountT,
      Currency_code:String(3)
    )returns String;

    action updateAddress(
      NODE_KEY:UUID,
      CITY:common.String255,
    )returns String;

    action createProduct(
      CATEGORY: common.String32,
  CURRENCY_CODE: String(5),
  DEPTH: Decimal(5,2),
  DESCRIPTION: common.String255,
  DIM_UNIT: String(2),
  HEIGHT: Decimal(5,2),
  MEASURE_UNIT: String(2),
  NODE_KEY: common.Guid,
  PRICE: Decimal(15,2),
  PRODUCT_ID: common.String32,
  TAX_TARRIF_CODE: Integer,
  TYPE_CODE: String(2),
  WEIGHT_MEASURE: Decimal(5,2),
  WEIGHT_UNIT: String(2),
  WIDTH: Decimal(5,2)
    )returns array of ProductSrv;


    action deleteEmployee(
      ID:UUID
    ) returns String;



    //custom functions

    function getHighestSalariedEmployees() returns array of EmployeeSrv;

    function getHighestPriceProducts() returns array of ProductSrv;

    //utility functions

    function getUtilities() returns String;

}

