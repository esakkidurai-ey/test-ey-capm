sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'managepurchaseorder/test/integration/FirstJourney',
		'managepurchaseorder/test/integration/pages/POsList',
		'managepurchaseorder/test/integration/pages/POsObjectPage',
		'managepurchaseorder/test/integration/pages/PurchaseOrderItemsObjectPage'
    ],
    function(JourneyRunner, opaJourney, POsList, POsObjectPage, PurchaseOrderItemsObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('managepurchaseorder') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onThePOsList: POsList,
					onThePOsObjectPage: POsObjectPage,
					onThePurchaseOrderItemsObjectPage: PurchaseOrderItemsObjectPage
                }
            },
            opaJourney.run
        );
    }
);