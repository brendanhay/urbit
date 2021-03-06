export default class Subscription {
  constructor(store, api, channel) {
    this.store = store;
    this.api = api;
    this.channel = channel;

    this.channel.setOnChannelError(this.onChannelError.bind(this));
    this.firstRoundComplete = false;
  }

  start() {
    if (this.api.ship) {
      this.firstRound();
    } else {
      console.error('~~~ ERROR: Must set api.ship before operation ~~~');
    }
  }

  delete() {
    this.channel.delete();
  }

  onChannelError(err) {
    console.error('event source error: ', err);
    console.log('initiating new channel');
    this.firstRoundComplete = false;
    setTimeout(2000, () => {
      this.store.handleEvent({
        data: { clear : true }
      });

      this.start();
    });
  }

  subscribe(path, app) {
    this.api.bind(path, 'PUT', this.api.ship, app,
      this.handleEvent.bind(this),
      (err) => {
        console.log(err);
        this.subscribe(path, app);
      },
      () => {
        this.subscribe(path, app);
      });
  }

  firstRound() {
    this.subscribe('/sole/' + this.api.dojoId, 'dojo');
  }

  handleEvent(diff) {
    this.store.handleEvent(diff);
  }
}

