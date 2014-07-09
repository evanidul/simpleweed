// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs

//= require bootstrap
//= require_tree .

$(document).ajaxSend(function(event, request, settings) {	
	$('#loading-indicator').center();
    $('#loading-indicator').show();        
});

$(document).ajaxComplete(function(event, request, settings) {
    $('#loading-indicator').hide();
});

/** http://stackoverflow.com/questions/4461247/centering-a-div-with-a-loading-spinner-gif-using-jquery-and-ajax-beginform **/
jQuery.fn.center = function () {
    this.css("position", "absolute");
    this.css("top", ($(window).height() - this.height())/ 2 + $(window).scrollTop() + "px");
    this.css("left", ($(window).width() - this.width()) / 2 + $(window).scrollLeft() + "px");
    return this;
}
            
/** allows you to popup bootstrap warnings/alerts with javascript **/
/** use: bootstrap_alert.warning('You cannot cast more than 1 vote per review'); **/
/** level : 
    "success" : green
    "danger" : red
            
  **/
bootstrap_alert = function() {}
bootstrap_alert.warning = function(message, selector, level) {    
    if (!level) {
        level = "danger"             
    }    
    newalert_html = '<div class="alert alert-'+ level +' alert-dismissable"><button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button><div class="flash_notice">'+message+'</div></div>'
    if(!selector) {
    	$('#bootstrap-alert').html(newalert_html)
    } else {
    	$(selector).html(newalert_html)
    }

}            