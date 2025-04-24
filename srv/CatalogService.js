module.exports = cds.service.impl( async function() {
    const {POs, EmployeeSet} = this.entities;

    // Action code
    this.on('boost', async(req, res) => {
        try {
            const ID = req.params[0];
            console.log("Hey Amigo, Your purchase order with id " + req.params[0].ID + " will be boosted");
            // In Capm, we will not fire db query directly. Instead, we will open a transaction using tx => It is a CDS Query Language
            const tx = cds.tx(req);
            await tx.update(POs).with({
                GROSS_AMOUNT: { '+=' : 20000 },
            }).where(ID);
        }
        catch (error) {
            return "Error " + error.toString() 
        }
    });

    // Function Code
    this.on('getLargestOrder', async (req,res) => {
        try {   
            const tx = cds.tx(req);
           
            //SELECT * UPTO 1 ROW FROM dbtab ORDER BY GROSS_AMOUNT desc
            const reply = await tx.read(POs).orderBy({
                GROSS_AMOUNT: 'desc'
            }).limit(1);
            return reply;
        }
        catch (error) {
            return "Error " + error.toString();
        }
    });

    // Event Handler - before
    this.before('CREATE', EmployeeSet, async(req, res) => {
        var EmployeeSalary = req.data.salaryAmount;
        console.log( "Your Salary " + EmployeeSalary);
        if(parseFloat(EmployeeSalary) >= 1000000) {
            req.error(500, "Salary overflow")
        }
    });

})