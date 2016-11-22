#= require action_cable

this.App = {};


App.cable = ActionCable.createConsumer("ws://localhost:28080");

//App.cable = ActionCable.createConsumer("ws://www.dogo.com:28080");
