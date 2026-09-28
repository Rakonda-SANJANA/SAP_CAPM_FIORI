const cds= require('@sap/cds')
module.exports=cds.service.impl(async function(){

    //1. declare employee service from entities
    const {EmployeeSrv}=this.entities;
    const {AddressSrv}=this.entities;
    const {ProductSrv}=this.entities;
    const {PurchaseOrderSrv}=this.entities;

    //implementation of an action
    //there are 3 generic handlers
    //.before():pre check and validation
    //.on(): peforming db operations
    //.after():to save/close connections

    this.on('createAddress',async(request,response)=> {
        //2. get the data which is coming from the API.
        const empData=request.data;
        //3.instantiate the transaction object
        const objTransaction=cds.tx(request);
        //4. insert the record into the database
        let returnData=await objTransaction.run([
            INSERT.into(AddressSrv).entries(empData)
        ]).then((resolve,reject)=>{
            if(typeof(resolve)!==undefined){
                return request.data
            }
            else{
                request.error(500,"Error inserting into the database.")
            }
        }).catch(err=>{
            request.error("There is an error: ",err.toString())
        })
        //5.return the data
        return returnData;
    })


    this.on('createEmployee',async(request,response)=> {
        //2. get the data which is coming from the API.
        const empData=request.data;
        //3.instantiate the transaction object
        const objTransaction=cds.tx(request);
        //4. insert the record into the database
        let returnData=await objTransaction.run([
            INSERT.into(EmployeeSrv).entries(empData)
        ]).then((resolve,reject)=>{
            if(typeof(resolve)!==undefined){
                return request.data
            }
            else{
                request.error(500,"Error inserting into the database.")
            }
        }).catch(err=>{
            request.error("There is an error: ",err.toString())
        })
        //5.return the data
        return returnData;
    })


    this.on('updateEmployee',async(request,response)=>{
        const{
            ID,
            salaryAmount,
            Currency_code
        }=request.data;
        try{
            const objTransaction=cds.tx(request);
            await objTransaction.update(EmployeeSrv).with({
                salaryAmount: salaryAmount,
                Currency_code:Currency_code
            }).where({
                ID:ID
            })
            return "Successfully updated.";
        } catch(error){
            request.error("Error:",error)
        }
    })


    this.on('updateAddress',async(request,response)=>{
        const{NODE_KEY,
            CITY
        }=request.data;
        try{
            const objTransaction=cds.tx(request);
            await objTransaction.update(AddressSrv).with({
                CITY:CITY
            }).where({
                NODE_KEY:NODE_KEY
            })
            return "Successfully updated.";
        } catch(error){
            request.error("Error:",error)
        }
    })


    this.on('createProduct',async(request,response)=> {
        //2. get the data which is coming from the API.
        const empData=request.data;
        //3.instantiate the transaction object
        const objTransaction=cds.tx(request);
        //4. insert the record into the database
        let returnData=await objTransaction.run([
            INSERT.into(ProductSrv).entries(empData)
        ]).then((resolve,reject)=>{
            if(typeof(resolve)!==undefined){
                return request.data
            }
            else{
                request.error(500,"Error inserting into the database.")
            }
        }).catch(err=>{
            request.error("There is an error: ",err.toString())
        })
        //5.return the data
        return returnData;
    })
    

    this.on('deleteEmployee',async(request,response)=> {
        const {ID}=request.data;
        try{
            const objTransaction=cds.tx(request);
            await objTransaction.delete(EmployeeSrv).where({
                ID:ID
            })
            return "Successfully deleted.";
        }
        catch(error){
            request.error("Error: ",error)
        }
    })

    this.before('UPDATE',EmployeeSrv,async(request,response)=>{
        const salaryAmt=request.data.salaryAmount;
        if(salaryAmt>100000){
            request.error(500,'Please get your approval from your line manager.');
        }
    })




    this.on('getHighestSalariedEmployees', async (request) => {
    try {
        const tx = cds.tx(request);

        const result = await tx.read(EmployeeSrv)
            .orderBy({ salaryAmount: 'desc' })
            .limit(10);

        return result;
    } catch (error) {
        request.error(500, error.message);
    }
});



   this.on('getHighestPriceProducts', async (request) => {
    try {
        const tx = cds.tx(request);

        const result = await tx.read(ProductSrv)
            .orderBy({ PRICE: 'desc' })
            .limit(10);

        return result;
    } catch (error) {
        request.error(500, error.message);
    }
});



    this.on('discountPrice',async(request,response)=>{
        try{
            const ID=request.params[0];
            const transaction=cds.tx(request);
            await transaction.update(PurchaseOrderSrv).with({
                GROSS_AMOUNT:{
                    '-=':1000
                },
                NET_AMOUNT:{
                    '-=':800
                },
                TAX_AMOUNT:{
                    '-=':200
                }
            }).where(ID)
            const updatePOInfo=await transaction.read(PurchaseOrderSrv);
            return updatePOInfo;
        } catch(error){
            return "Error: "+error.toString();
        }
    });


        this.on('largestOrder',async(request,response)=>{
        try{
            const transaction=cds.tx(request);
            const reply=await transaction.read(PurchaseOrderSrv).orderBy({
                GROSS_AMOUNT:'desc'
            }).limit(5);
            return reply;
        } catch(error){
            return "Error: "+error.toString();
        }
    });




    

    // Instance Bounded Action
    // Increase selected product price by 10%

    this.on('increasePrice', ProductSrv, async (req) => {

        try {

            const tx = cds.tx(req);

            const { NODE_KEY } = req.params[0];

            const product = await tx.read(ProductSrv)
                .where({ NODE_KEY });

            if (!product.length) {
                return req.error(404, 'Product not found');
            }

            const currentPrice = product[0].PRICE;

            const updatedPrice = Number(currentPrice) * 1.10;

            await tx.update(ProductSrv)
                .set({
                    PRICE: updatedPrice
                })
                .where({
                    NODE_KEY
                });

            return {
                message: 'Product price increased by 10%',
                oldPrice: currentPrice,
                newPrice: updatedPrice
            };

        } catch (error) {
            req.error(500, error.message);
        }

    });






    this.on('increaseSalary', EmployeeSrv, async (req) => {
    try {
        const tx = cds.tx(req);

        const { ID } = req.params[0]; // cuid entity key

        const employee = await tx.read(EmployeeSrv)
            .where({ ID });

        if (!employee.length) {
            return req.error(404, 'Employee not found');
        }

        const currentSalary = employee[0].salaryAmount;
        const updatedSalary = Number(currentSalary) * 1.15;

        await tx.update(EmployeeSrv)
            .set({
                salaryAmount: updatedSalary
            })
            .where({
                ID
            });

        return {
            message: 'Employee salary increased by 15%',
            oldSalary: currentSalary,
            newSalary: updatedSalary
        };

    } catch (error) {
        req.error(500, error.message);
    }
});



    this.on('getTopEmployees', EmployeeSrv, async (req) => {

        try {

            const tx = cds.tx(req);

            const result = await tx.run(
                SELECT.from(EmployeeSrv)
                    .orderBy({ salaryAmount: 'desc' })
                    .limit(20)
            );

            return result;

        } catch (error) {
            req.error(500, error.message);
        }

    });



    // Instance Bounded Function
    // Top 20 products by price

    this.on('getTopProducts', ProductSrv, async (req) => {

        try {

            const tx = cds.tx(req);

            const result = await tx.run(
                SELECT.from(ProductSrv)
                    .orderBy({ PRICE: 'desc' })
                    .limit(20)
            );

            return result;

        } catch (error) {
            req.error(500, error.message);
        }

    });

    const{uuid,exists,isdir,read}=cds.utils;
    this.on('getUtilities', async(request,response)=>{
        let vUUID=uuid(),vPackageContent=null,vInput="%E%A4%A",uri,dirExists=false,isFileExists=false;
        if(exists('srv/request.http')){
            isFileExists=true;
        }
        if(isdir('app'))
        {
            dirExists=true;
        }
        try{
            uri=decodeURI(vInput);
            await mkrdirp('srv/lib')
        }catch{
            uri=vInput;
        }
        vPackageContent=await read('package.json');
        var finalValue={
            uuid:vUUID,
            uri:uri,
            isFileExists:isFileExists,
            dirExists:dirExists,
            packageInfo:vPackageContent
        }
        return finalValue;
    })
})