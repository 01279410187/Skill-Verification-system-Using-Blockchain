// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;


contract DSkill{




   struct Company {
    uint256 id;
    string name;
    address wallet_address;
    uint256[] currunt_employees;
    uint256[] previous_employees;
    uint256[] requested_employees;
   }

  struct User{
    uint256 id;
    uint256 company_id;
    string name;
    address wallet_address;
    bool is_employed;
    bool is_manager;
    uint256 num_skill;
    uint256[] user_skills;
    uint256[] user_work_experience;
  }


  struct Experience{
    string start_date;
    string end_date;
    string role;
    bool curruntly_working;
    uint256 company_id;
    bool is_approved;
  }

    mapping(string=>address) public email_to_address;
    mapping(address=>uint256) public address_to_id;
    mapping(address=>bool) public is_company;

    Company[] companies;
    User[] employees;
    Experience[] experiences;
    function memcmp(bytes memory a, bytes memory b)
        internal
        pure
        returns (bool)
    {
        return (a.length == b.length) && (keccak256(a) == keccak256(b));
    }
    function strcmp(string memory a, string memory b)
        internal
        pure
        returns (bool)
    {
        return memcmp(bytes(a), bytes(b));
    }
    // function signUp
    function sign_up(string calldata name,string calldata email,string calldata account_type)public{

        require(email_to_address[email]==address(0),"user is already exist");
        email_to_address[email]=msg.sender;
        if(strcmp(account_type,"user")){
            User storage new_user=employees.push();
            new_user.name=name;
            new_user.id=employees.length-1;
            new_user.wallet_address=msg.sender;
            address_to_id[msg.sender]=new_user.id;
            new_user.user_skills=new uint256[](0);
            new_user.user_work_experience=new uint256[](0);
            new_user.is_employed=true;
        }else{
            Company storage new_company=companies.push();
            new_company.name=name;
            new_company.id=companies.length-1;
            new_company.wallet_address=msg.sender;
            address_to_id[msg.sender]=new_company.id;
            new_company.currunt_employees=new uint256[](0);
            new_company.previous_employees=new uint256[](0);
            new_company.requested_employees=new uint256[](0);
            is_company[msg.sender]=true;
        }
    }


    //function login
    function login(string calldata email)public view returns(string memory){
        require(msg.sender==email_to_address[email],"incorrect wallet address used for signing in");
        return (is_company[msg.sender]) ? "company":"user";

    }

    //update wallet address

    function update_wallet_address(string calldata email,address new_address)public{

        require(email_to_address[email]==msg.sender,"error: function called from incorrect wallet address");

        email_to_address[email]=new_address;

        uint256 id= address_to_id[msg.sender];

        address_to_id[msg.sender]=0;

        address_to_id[new_address]=id;
    }




}