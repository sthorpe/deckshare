App.messages = App.cable.subscriptions.create("MessagesChannel", {
  collection: function() {
    return $("[data-channel='messages']");
  },
  connected: function() {
    return setTimeout((function(_this) {
      return function() {
        _this.followCurrentMessage();
        return _this.installPageChangeCallback();
      };
    })(this), 1000);
  },
  received: function(data) {
    if (!this.userIsCurrentUser(data.message)) {
      return this.collection().append(data.message);
    }
  },
  userIsCurrentUser: function(message) {
    return $(message).attr('data-user-id') === $('meta[name=current-user]').attr('id');
  },
  followCurrentMessage: function() {
    var messageId;
    if (messageId = this.collection().data('message-id')) {
      return this.perform('follow', {
        message_id: messageId
      });
    } else {
      return this.perform('unfollow');
    }
  },
  installPageChangeCallback: function() {
    if (!this.installedPageChangeCallback) {
      this.installedPageChangeCallback = true;
      return $(document).on('page:change', function() {
        return App.messages.followCurrentMessage();
      });
    }
  }
});
