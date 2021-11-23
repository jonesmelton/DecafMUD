// const ansicolor = require("ansicolor");

type DecafMud = {
  sendInput?: Function;
};
type DecafSocket = {};
class MudPipe {
  mud: DecafMud;
  socket: DecafSocket;
  constructor(decafMud: DecafMud = {}) {
    this.mud = decafMud;
  }

  setMud(mud: DecafMud) {
    this.mud = mud;
    return this;
  }

  setSocket(socket) {
    this.socket = socket;
  }

  mudSent(data: string) {
    console.log("fresh from the mud: ", data);
  }
  sendMud(input: string) {
    try {
      console.log(this.mud);
      this.mud.sendInput(input);
    } catch (error) {
      console.error(error);
    }
  }
}
