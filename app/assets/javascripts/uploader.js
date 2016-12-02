this.Uploader = function(){
}
Uploader.prototype = {
  detectFile: function(){
    $('.directUpload').find("input:file").each(function(i, elem) {
      self = this;
      var fileInput    = $(elem);
      var form         = $(fileInput.parents('form:first'));
      var submitButton = form.find('input[type="submit"]');
      var pdf          = $("#deckAttachment");
      var notifier     = $(".notifier");
      var progressBar  = $("<div class='pt-progress-meter' style='width:0%;'></div>");
      var barContainer = $("<div class='pt-progress-bar pt-intent-success' style='display:none;width:20%;'></div>").append(progressBar);
      fileInput.after(barContainer);
      fileInput.fileupload({
        fileInput:       fileInput,
        url:             form.data('url'),
        type:            'POST',
        autoUpload:       true,
        formData:         form.data('form-data'),
        paramName:        'file', // S3 does not like nested name fields i.e. name="user[avatar_url]"
        //dataType:         'XML',  // S3 returns XML if success_action_status is set to 201
        replaceFileInput: false,
        progressall: function (e, data) {
          var progress = parseInt(data.loaded / data.total * 100, 10);
          progressBar.css('width', progress + '%')
        },
        start: function (e) {
          submitButton.prop('disabled', true);
          barContainer.show();
        },
        done: function(e, data) {
          submitButton.prop('disabled', false);
          pdf.hide();
          barContainer.hide();
          notifier.text("Uploading done");
          // extract key and generate URL from response
          var key   = $(data.jqXHR.responseXML).find("Key").text();
          var url   = '//' + form.data('host') + '/' + key;

          // create hidden field
          var input = $("<input />", { type:'hidden', name: fileInput.attr('name'), value: url })
          form.append(input);
        },
        fail: function(e, data) {
          submitButton.prop('disabled', false);
          barContainer.removeClass('pt-intent-success');
          barContainer.addClass('pt-intent-danger');
          notifier.text("Failed");
        }
      });
    });
  },
  debug: function(){
    var file = $('#deckAttachment').prop('files')[0];
    var name = file.name;
    var size = file.size;
    var type = file.type;
    console.log(file, name, size, type);
  },
  loading: function(){
    $('body').empty();
    $('body').html('<center style="padding-top:20%;"><i class="fa fa-refresh fa-spin" style="font-size:124px"></i></center>');
    setTimeout(function() {
      location.reload();
    }, 4000)
  }
}
UPLOADER = new Uploader();
