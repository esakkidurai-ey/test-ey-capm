using CatalogService as service from '../../srv/CatalogService';
annotate service.POs with @(
    UI.SelectionFields:[
        PO_ID,
        PARTNER_GUID.COMPANY_NAME,
        PARTNER_GUID.ADDRESS_GUID.COUNTRY,
        GROSS_AMOUNT,
        OVERALL_STATUS
    ],
    UI.LineItem:[
        {
            $Type : 'UI.DataField',
            Value : PO_ID,
        },
        {
            $Type : 'UI.DataField',
            Value : PARTNER_GUID.COMPANY_NAME,
        },
        {
            $Type : 'UI.DataField',
            Value : PARTNER_GUID.ADDRESS_GUID.COUNTRY,
        },
        {
            $Type : 'UI.DataField',
            Value : GROSS_AMOUNT,
        },
        {
            $Type: 'UI.DataFieldForAction',
            Label: 'Boost Gross Amount',
            Action: 'CatalogService.boost',
            Inline: true
        },
        {
            $Type : 'UI.DataField',
            Value : OverallStatus,
            Criticality: Critical
        },
    ],
    UI.HeaderInfo:{
        TypeName : 'Purchase Order',
        TypeNamePlural : 'Purchase Orders',
        Title : {Value: PO_ID},
        Description: {Value: OverallStatus}
    },
    UI.Facets: [
        {
            $Type: 'UI.CollectionFacet',
            Label: 'Detailed Information',
            Facets: [
                {
                    $Type: 'UI.ReferenceFacet',
                    Target: '@UI.Identification',
                    Label: 'Purchase Order Info'
                },
                {
                    $Type: 'UI.ReferenceFacet',
                    Target: '@UI.FieldGroup#Spider',
                    Label: 'Pricing Info'
                },
                {
                    $Type: 'UI.ReferenceFacet',
                    Target: '@UI.FieldGroup#Super',
                    Label: 'Contact Info'
                }
            ]
        },
        {
            $Type: 'UI.ReferenceFacet',
            Label: 'PO Items',
            Target: 'Items/@UI.LineItem'
        }
    ],
    UI.Identification: [
        {
            $Type: 'UI.DataField',
            Value: NODE_KEY
        },
        {
            $Type: 'UI.DataField',
            Value: PO_ID
        },
        {
            $Type : 'UI.DataField',
            Value : PARTNER_GUID_NODE_KEY,
        }
    ],
    UI.FieldGroup#Spider:{
        
        Data: [
        {
            $Type: 'UI.DataField',
            Value: CURRENCY_code
        },
        {
            $Type: 'UI.DataField',
            Value: GROSS_AMOUNT
        },
        {
            $Type: 'UI.DataField',
            Value: NET_AMOUNT
        },
        {
            $Type: 'UI.DataField',
            Value: TAX_AMOUNT
        }
        ]
    },
    UI.FieldGroup#Super:{
        
        Data: [
        {
            $Type: 'UI.DataField',
            Value: PARTNER_GUID.EMAIL_ADDRESS
        },
        {
            $Type: 'UI.DataField',
            Value: PARTNER_GUID.PHONE_NUMBER
        },
        {
            $Type: 'UI.DataField',
            Value: PARTNER_GUID.WEB_ADDRESS
        },
        {
            $Type: 'UI.DataField',
            Value: OVERALL_STATUS
        }
        ]
    }
);

annotate service.PurchaseOrderItems with @(
    UI.LineItem: [
        {
            $Type : 'UI.DataField',
            Value : PARENT_KEY.NODE_KEY,
        },
        {
            $Type : 'UI.DataField',
            Value : NODE_KEY,
        },
        {
            $Type : 'UI.DataField',
            Value : PO_ITEM_POS,
        },
        {
            $Type : 'UI.DataField',
            Value : PRODUCT_GUID.PRODUCT_ID,
        },
        {
            $Type : 'UI.DataField',
            Value : PRODUCT_GUID.DESCRIPTION,
        },
        {
            $Type : 'UI.DataField',
            Value : PRODUCT_GUID.CATEGORY,
            
        },
        {
            $Type : 'UI.DataField',
            Value : PARENT_KEY.OverallStatus,
            Criticality: PARENT_KEY.Critical
            
        },
    ],
    UI.HeaderInfo:{
        TypeName : 'Item',
        TypeNamePlural : 'Items',
        Title : {Value: NODE_KEY},
        Description: {Value: PARENT_KEY.OverallStatus}
    },
);

annotate service.POs with {
    PARTNER_GUID@(
        Common:{
            Text : PARTNER_GUID.COMPANY_NAME,
        },
        ValueList.entity:CatalogService.BusinessPartnerSet
    )
}

@cds.odata.valuelist
annotate service.BusinessPartnerSet with @(
    UI.Identification:[{
        $Type: 'UI.DataField',
        Value: COMPANY_NAME
    }]
);

annotate service.POs with {
    OVERALL_STATUS @Common.ValueList: {
        CollectionPath: 'OverallStatusVH',
        Parameters: [
            {
                $Type: 'Common.ValueListParameterInOut',
                LocalDataProperty: 'OVERALL_STATUS',
                ValueListProperty: 'Status'
            },
            {
                $Type: 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'DisplayText'
            }
        ]
    };
};
@cds.odata.valuelist
annotate service.OverallStatusVH with @(
    UI.Identification: [
        { $Type: 'UI.DataField', Value: Status },
        { $Type: 'UI.DataField', Value: Text }
    ]
);

