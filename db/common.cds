/*namespace poapplication.common;
using {Country,Currency} from '@sap/cds/common';
type nameStr:String(50);
type nameInt:Integer;
aspect address{
    drno: String(20);
    street:nameStr;
    landmark:String(100);
    city:String(20);
    postal:Integer;
    state:String(20);
    country:Country;
    region:String(20);
}
aspect feeasp{
    gross_fee:AmountT;
    tax:AmountT;
    total_fee:AmountT;
    currency:Currency;
}
type Gender : String enum {
        Male   = 'M';
        Female = 'F';
        Other  = 'O';
    }
type AmountT:Decimal(10,2) @(
    Semantics.amount.currencyCode:'CURRENCY_CODE',
    sap.unit:'CURRENCY_CODE'
    );
type PhoneNumber:String(20) @assert.format: ' ^(?:(?:\+|00)?91[\-\s]?)?[6-9]\d{9}$';
type Email : String(100)
@assert.format: '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$'; */

namespace poapplication.common;
using {Currency} from '@sap/cds/common';

type Guid:UUID;
type PhoneNumber:String(32);
type Email:String(225);
type Role:String(2);
type String32:String(32);
type String64:String(64);
type String255:String(255);

type Gender: String(1) enum{
    male='M';
    female='F';
    undisclosed='D';
}

type AmountT:Decimal(10,2) @(
    Semantics.amount.currencyCode:'CURRENCY_CODE',
    sap.unit:'CURRENCY_CODE'
);
aspect Address{
    STREET:String255;
    POSTAL_CODE:String(12);
    CITY:String255;
    COUNTRY:String255;
    BUILDING:String255;
}

aspect Amount{
    GROSS_AMOUNT:AmountT;
    NET_AMOUNT:AmountT;
    TAX_AMOUNT:AmountT;
    CURRENCY:Currency;
}
