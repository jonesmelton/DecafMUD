const connection = new WebSocket("ws://discworld.starturtle.net:4243");

connection.onopen = function (event: Event) {
  console.log("connection event: ", event);

  connection.send("Here's some text that the server is urgently awaiting!");
};

connection.addEventListener("message", function (event) {
  const incoming = formatFromMud(event);
  console.log("Message from server ", incoming);
});

type AnsiString = string;
// original name .write()
function formatForMud(data: AnsiString) {
  const text = [];
  for (let i = 0; i < data.length; i++) text[i] = data.charCodeAt(i);
  const arr = new Uint8Array(text).buffer;
  return arr;
}

type MudEvent = { data: ArrayBuffer };
// original name .onMessage()
function formatFromMud(event: MudEvent) {
  console.log("preformat event: ", event.data);
  const u8 = new Uint8Array(event.data);
  let rq = "";
  for (let i = 0; i < u8.length; i++) {
    rq += String.fromCharCode(u8[i]);
  }
  return rq;
}
