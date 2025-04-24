using { esk.db.master, esk.db.transaction } from '../db/datamodel';
using { esk.cdsviews.CDSViews } from '../db/CDSViews';


service CatalogService @(path: 'CatalogService') {
    // @readonly
    entity EmployeeSet as projection on master.employees;
    
    entity BusinessPartnerSet as projection on master.businesspartner;
    entity AddressSet as projection on master.address;

    entity PurchaseOrderItems as projection on transaction.poitems;
    entity POs @(odata.draft.enabled: true) as projection on transaction.purchaseorder {
        *,
        // round(GROSS_AMOUNT) as GROSS_AMOUNT: Decimal(10,2),
        Items: redirected to PurchaseOrderItems,

        OVERALL_STATUS, // ✅ Expose actual editable field

        case OVERALL_STATUS
            when 'P' then 'Pending'
            when 'A' then 'Approved'
            when 'R' then 'Rejected'
            else 'Open' end as OverallStatus : String(10) @(title: '{i18n>OVERALL_STATUS}'),

        case OVERALL_STATUS
            when 'P' then 2
            when 'A' then 3
            when 'R' then 1
            else 2 end as Critical : Integer


    }actions{
        @Common : { SideEffects : {
            $Type : 'Common.SideEffectsType',
            TargetProperties : [
                'in/GROSS_AMOUNT',
            ],
        }, }

        action boost() returns POs;
    };

    entity OverallStatusVH as projection on master.OverallStatusVH;

    function getLargestOrder() returns POs;

    // entity ProductView as projection on CDSViews.ProductView;

    entity ProductSet as projection on master.product;

}
