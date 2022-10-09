import logo from "./logo.svg";

import Web3 from "web3";

import SmartContract from "./abis/DSkill.json";

import { useState } from "react";

const contractAddress = "0x661FB1700B102786980dA7f9260329f2Fe679CAa";
function App() {
  const [state, setState] = useState({
    web3: null,
    contract: null,
    email: "",
    account: "",
    accountId: "",
    signedIn: false,
    loaded: false,
  });
  // const [Account, setAccount] = useState("")

  const initWeb3 = async () => {
    if (window.ethereum) {
      await window.ethereum.request({ method: "eth_requestAccounts" });
      try {
        const web3 = new Web3(window.ethereum);
        const account = (await web3.eth.getAccounts())[0];
        const contract = new web3.eth.Contract(
          SmartContract.abi,
          contractAddress
        );
        const accountId = await contract.methods.address_to_id(account).call();
        setState({
          ...state,
          web3,
          account,
          contract,
          accountId,
          loaded: true,
        });
        console.log("setup complete");
      } catch (e) {
        alert(e);
      }
    } else {
      alert("web3 not detected");
    }
  };

  const login = async () => {
    try {
      const accountType = await state.contract.methods.login(Email).call({
        from: state.account,
      });
      console.log("account type", accountType);
      setState({ ...state, signedIn: true });
    } catch (error) {
      console.log(error);
    }
  };
  const [Name, setName] = useState("");
  const [Email, setEmail] = useState("");
  const [Type, setType] = useState();
  const siginUp = async () => {
    try {
      await state.contract.methods
        .sign_up(Email, Name, Type)
        .send({ from: state.account });
      alert("signed up");
    } catch (error) {
      console.log(error);
    }
  };
  return (
    <div>
      <div style={{ display:"flex",justifyContent:"space-around"}}>
        <div>
        <button style={{ backgroundColor: "#eee" }} onClick={initWeb3}>
            connect Wallet
          </button>
         
          <p id="email">email</p>
          <input
            type=""
            id="email"
            value={Email}
            onChange={(e) => setEmail(e.target.value)}
          />
          <p id="name">Name</p>
          <input
            type="text"
            id="name"
            value={Name}
            onChange={(e) => setName(e.target.value)}
          />
          <br />
          <div style={{ marginTop: "5px" }}>
            <input
              type="checkbox"
              id="type"
              value={()=>setType("user")}
              onChange={(e) => setType(e.target.value)}
            />
            <span style={{ padding: "2px" }}>User</span>
            <input
              type="checkbox"
              id="type"
              value={()=>setType("company")}
              onChange={(e) => setType(e.target.value)}
            />
            <span style={{ padding: "2px" }}>Company</span>
            <br />
          </div>
           
          <button style={{ backgroundColor: "#eee",marginTop:"20px"}} onClick={siginUp}>
            siginUp
          </button>
        </div>
        <div>
        <p id="email">email</p>
          <input
            type=""
            id="email"
            value={Email}
            onChange={(e) => setEmail(e.target.value)}
          />
          <button style={{ backgroundColor: "#eee",marginTop:"20px"}} onClick={login}>
            login
          </button>
          {state.account ?  <><h4> Account Details</h4>
          <p>{state.account}</p>
          <p>{Name}</p>
          <p>{Email}</p>
          <p>{Type}</p></>:null}
        </div>
      </div>
    </div>
  );
}

export default App;
