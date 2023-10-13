const songCID = "bafybeiabcpfbmng5nwtltsnj75cv3amcdegrxxndpdgkj4podm3dakoilm"; // Replace with the actual CID of your song

// URL for retrieving the song data
const nftStorageURL = `https://nft.storage/ipfs/${songCID}`;

const audioContainer = document.getElementById("audio-container");

// Create an audio element
const audio = document.createElement("audio");
audio.controls = true;

// Create a source element and set its attributes
const source = document.createElement("source");
source.src = `https://bafybeiabcpfbmng5nwtltsnj75cv3amcdegrxxndpdgkj4podm3dakoilm.ipfs.nftstorage.link`;
source.type = "audio/mp3";

// Append the source element to the audio element
audio.appendChild(source);

// Append the audio element to the container
audioContainer.appendChild(audio);
