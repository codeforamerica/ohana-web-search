define(['module/busy-manager'] , function (BusyManager) {
  
  fixture.preload("busy-manager_fixture.html"); // make the actual requests for the files

  describe('busy-manager' , function () {
    
  	beforeEach(function() {
    	this.fixtures = fixture.load("busy-manager_fixture.html", true); 
   	});

    // ADD YOUR SPEC
    it( "should hide the splash screen", function () {
    	BusyManager.init();
    	BusyManager.hide();
      //expect( $("#splash-screen", fixture.el).css('display') ).toBe("none");
    });


  });

});