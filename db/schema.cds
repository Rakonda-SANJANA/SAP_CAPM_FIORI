//namespace poapplication;
//using {poapplication.common as common } from './common';
//using{managed ,temporal , Currency} from '@sap/cds/common';
//This is the syntax for custom reusable type
//using{managed ,temporal} from '@sap/cds/common';

/*entity Students:common.address,common.feeasp,managed,temporal{
    key StudentId:common.nameInt;
    studentName: common.nameStr;
    fatherName: common.nameStr;
    motherName: common.nameStr;
    contactNo: common.PhoneNumber;
    fee: Decimal;
    mail:common.Email;
    currency: Currency;
    //managed association
    abc: Association to Classes;
    //unmanaged association
    mark:Association to many Marks on mark.parent1 =$self;
    book: Association to many Books on book.parent =$self;
    gender:common.Gender;
}*/

/*entity Classes:managed,temporal{
    key classId: common.nameInt;
    className: common.nameStr;
    teacherName: common.nameStr;
    
}*/
/*entity Marks:managed, temporal{
    key studentId: Integer;
    parent1:Association to Students;
    subject: common.nameStr;
    total: Integer;
    
}*/

/*entity Books{
    key BookId: Integer;
    parent:Association to Students;
    studentName: common.nameStr;
    bookauthor:common.nameStr;
    price: Decimal(10,2);
    doi: Date;
    dor: Date;
}*/

//This is the syntax for identifier
//type ![EmployeeName]:String(50);

/*entity Employees{
    key empId: Integer;
    empName:String(50);
    salary:String(50);
    dept:String(50);
    currencycode:Integer;
    city:String(50);
    country:String(50);
    division: Association to one Divisions;

}*/

/*entity Divisions{
    key divisionId:Integer;
    divisionName:String(50);
    city:String(50);
    Country:String(50);

}*/


/*entity Photos:managed,temporal{
    key id:Integer;
    albumId:Association to Albums;
    locationId:Association to Locations;
    memberId:Association to Members;
    title:String(120);
    description:String(120);
    privacy:String(120);
    uploadDate:Date;
    view:Integer;
    imagePath:String(100);
}*/

/*entity Locations{
    key id:Integer;
    name: String(50);
    shortName:String(50);
}*/

/*entity Comments{
    key id:Integer;
    photoId:Association to Photos;
    postDate:Date;
    content: String(50);
}*/
/*entity Members{
    key id:Integer;
    name:String(50);
    phone:Integer;
    email:String(100);
    address:String(120);
}*/

/*entity Albums{
    key id:Integer;
    albumTitle:String(100);
    description:String(120);
    view:Integer;
}*/

 /*entity Tags{
    key id:Integer;
    tagTitle:String(100);
 }*/

 /*entity TagPhotos{
    key id:Integer;
    tagId:Association to Tags;
    PhotoId:Association to Photos;
 }*/

//------------------------------------------------------------------------






namespace poapplication.db;
using {cuid,Currency} from '@sap/cds/common';
using{ poapplication.common as common} from './common';

context master{
    entity BusinessPartners{
        key NODE_KEY: common.Guid;
        BP_ROLE: common.Role;
        EMAIL:common.Email;
        MOBILE:common.PhoneNumber;
        FAX:common.String32;
        WEB:common.String255;
        BP_ID:common.Guid;
        COMPANY_NAME:common.String255;
        //managed association
        AD:Association to Addresses;
    }
    entity Addresses: common.Address{
        key NODE_KEY:common.Guid;
        ADDRESS_TYPE:common.String32;
        VAL_START:Date;
        VAL_END:Date;
        LATITUDE:Decimal;
        LONGITUDE:Decimal;
        //unmanaged association
        BP:Association to one BusinessPartners on BP.AD=$self;
    }
    entity Products{
        key NODE_KEY:common.Guid;
        PRODUCT_ID:common.String32;
        TYPE_CODE:String(2);
        CATEGORY:common.String32;
        DESCRIPTION:common.String255;
        TAX_TARRIF_CODE:Integer;
        MEASURE_UNIT:String(2);
        WEIGHT_MEASURE:Decimal(5,2);
        WEIGHT_UNIT:String(2);
        PRICE:Decimal(15,2);
        CURRENCY_CODE:String(5);
        WIDTH:Decimal(5,2);
        DEPTH:Decimal(5,2);
        HEIGHT:Decimal(5,2);
        DIM_UNIT:String(2);
        //Managed association
        SUPPLIERS:Association to BusinessPartners;
    }
    entity Employees:cuid{
        nameFirst:common.String64;
        nameLast:common.String64;
        nameInitials:common.String64;
        nameMiddle:common.String64;
        gender:common.Gender;
        language:String(2);
        loginName:String(16);
        phoneNumber:common.PhoneNumber;
        email:common.Email;
        Currency:Currency;
        salaryAmount:common.AmountT;
        accountNumber:common.String32;
        bankId:String(16);
        bankName:common.String64;
    }
}

context transaction{
    entity PurchaseOrders:common.Amount{
        key NODE_KEY:common.Guid;
        PO_ID:common.Guid;
        //managed association
        PARTNER:Association to master.BusinessPartners;
        LIFECYCLE_STATUS:String(1);
        OVERALL_STATUS:String(1);
        //unmanaged association
        Items:Association to many PurchaseItems on Items.PARENT=$self;
    }
    entity PurchaseItems:common.Amount{
        key NODE_KEY: common.Guid;
        //parent key
        PARENT: Association to PurchaseOrders;
        PO_ITEM_POS:Integer;
        //managed association
        PRODUCT: Association to master.Products;
    }
}
