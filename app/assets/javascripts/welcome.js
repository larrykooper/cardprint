// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.


var authorizeSuccess = function(data, status) {
	console.log('authorization was successful');

}

var authorizeError = function(jqXHR, status, error) {
	console.log(status);
	console.log(error);
}

$(document).ready(function() {
    $("#done-button").click(function() {
        console.log( "Handler for .click() called.");
        $.ajax({
            url: '/spreadsheet/authorize',
            success: authorizeSuccess,
            error: authorizeError,
            dataType: 'json'
        });
    }); // end - click
});  // end- ready
