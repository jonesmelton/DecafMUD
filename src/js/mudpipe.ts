// const ansicolor = require("ansicolor");

type DecafMud = {
  sendInput?: Function;
};
type DecafSocket = {};
type ElmPorts = {
  sendToMud: any;
  sendToElm(line: string): void;
};
class MudPipe {
  mud: DecafMud;
  socket: DecafSocket;
  ports?: ElmPorts;

  constructor(decafMud: DecafMud = {}) {
    this.mud = decafMud;
  }
  setPorts(ports: ElmPorts): MudPipe {
    this.ports = ports;
    // this.ports.sendToMud.subscribe(this.sendMud);
    return this;
  }

  setMud(mud: DecafMud) {
    this.mud = mud;
    return this;
  }

  setSocket(socket) {
    this.socket = socket;
  }

  mudSent(data: string) {
    try {
      this.ports?.sendToElm?.(data);
    } catch (error) {
      console.log(error);
    }
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
