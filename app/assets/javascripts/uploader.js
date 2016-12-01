this.Uploader = function(){
}
Uploader.prototype = {
  detectFile: function(){
    this.debug();
    $('.directUpload').find("input:file").each(function(i, elem) {
      var fileInput    = $(elem);
      var form         = $(fileInput.parents('form:first'));
      var submitButton = form.find('input[type="submit"]');
      var progressBar  = $("<div class='bar'></div>");
      var barContainer = $("<div class='progress'></div>").append(progressBar);
      fileInput.after(barContainer);
      fileInput.fileupload({
        fileInput:       fileInput,
        url:             form.data('url'),
        type:            'POST',
        autoUpload:       true,
        formData:         form.data('form-data'),
        paramName:        'file', // S3 does not like nested name fields i.e. name="user[avatar_url]"
        dataType:         'XML',  // S3 returns XML if success_action_status is set to 201
        replaceFileInput: false
      });
    });
  },
  debug: function(){
    var file = $('#deckAttachment').prop('files')[0];
    var name = file.name;
    var size = file.size;
    var type = file.type;
    console.log(file, name, size, type);
  }
}
UPLOADER = new Uploader();
