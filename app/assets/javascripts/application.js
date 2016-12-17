//= require webpack-bundle

// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require bootstrap-sprockets
//= require jquery_ujs
//= require jquery-fileupload/basic
//= require action_cable
//= require_self
//= require_tree ./cable
//= require_tree .


this.App = {};
App.cable = ActionCable.createConsumer();

App.websiteSelect = function(){
  $('.website-select').on('change', function(){
    this
    debugger
    var strWeb = this.options[this.selectedIndex].text;
    data = { accountId: '', webPropertyId: ''};
    path = 'google_analytics_website_stats';
    App.ajaxController(data, path, 'POST');
  })
}

App.ajaxController = function(data, path, httpmethod){
  function build_url(path){
    return '/'+path;
  }

  function callback_receiving_data(){
  }
  $.ajax({
     url: build_url(path),
     method: httpmethod,
     data: data,
     success: function(){
       callback_receiving_data();
     }
  })
}
