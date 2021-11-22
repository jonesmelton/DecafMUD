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
