safari.self.addEventListener("message", handleMessage);

function handleMessage(message) {
    var selectedText = window.getSelection().toString();
    console.log("selected " + selectedText)
    safari.extension.dispatchMessage("getURL", { "selectedText": selectedText });
}
