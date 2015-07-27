// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require turbolinks
//= require_tree .
//= require bootstrap-sprockets
//= require card



// $('form').card({
// 	container: '.card-wrapper',

// 	formSelectors: {
// 		cvcInput: 'cvv',
// 		numberInput: 'card_number',
// 		expiryInput: 'exp_date',
// 	},

// });


jQuery(function($) {
	$('#new_transaction').card ({ 
		container: '.card-wrapper', 
		formSelectors: {
			nameInput: 'input#transaction_full_name',
			numberInput: 'input#transaction_card_number',
			expiryInput: 'input#transaction_exp_date',
			cvcInput: 'input#transaction_cvv'
		},

		// $("#transaction_card_number").val($.trim($("#transaction_card_number").val()));
		// $("input#transaction_card_number").replace(/\s/g, ' ');
		// expiryInput.replace(/\//g, '').onSubmit,
	});
	
	
	// var expiry
	
		// $.trim("input#transaction_card_number");


	// var expiryStr = "input#transaction_exp_date";
	// expiryStr.replace(/\//g, '');
	// var numStr = "input#transaction_card_number";
	// var new_numStr = numStr.replace(/\s/g, '');


	
});


