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
    string user_name;
  }
  struct Certificate{
    string url;
    string issue_date;
    string valid_till;
    string name;
    uint256 id;
    string issuer;
  }

  struct Endorsment {
    uint256 endorser_id;
    string date;
    string comment;
  }
  struct Skill {
    uint256 id;
    string name;
    bool verified;
    uint256[] skill_certifications;
    uint256[] skill_endorsements;
}

    mapping(string=>address) public email_to_address;
    mapping(address=>uint256) public address_to_id;
    mapping(address=>bool) public is_company;

    Company[] companies;
    User[] employees;
    Skill[]skills;
    Certificate[] certifications;
    Endorsment[] endorsments;
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

    modifier veryfiyUser(uint256 userId){
        require(userId==address_to_id[msg.sender]);
        _;
    }
    function add_experience(uint userId, string calldata starting_date,string calldata ending_date,string calldata role,uint256 company_id) veryfiyUser(userId) public{

        Experience storage new_experience= experiences.push();
        new_experience.start_date=starting_date;
        new_experience.end_date=ending_date;
        new_experience.company_id=company_id;
        new_experience.role=role;
        new_experience.curruntly_working=false;
        new_experience.is_approved=false;
        
        new_experience.user_name=employees[userId].name;
        employees[userId].user_work_experience.push(experiences.length-1);
        companies[company_id].requested_employees.push(experiences.length-1);


    }

    function approve_experience(uint256 exp_id,uint256 company_id)public{

        require((is_company[msg.sender]&& companies[address_to_id[msg.sender]].id==experiences[exp_id].company_id) || (employees[address_to_id[msg.sender]].is_manager && employees[address_to_id[msg.sender]].company_id==experiences[exp_id].company_id),"error: approver should be the company account or a manager of the required company");
         
        uint256 i;
        experiences[exp_id].is_approved=true;

        for (i=0 ;i< companies[company_id].requested_employees.length;i++){
            if(companies[company_id].requested_employees[i]==exp_id){
                companies[company_id].requested_employees[i]=0;
                break;
            }

        }

        for(i=0; i<companies[company_id].currunt_employees.length;i++){
            if(companies[company_id].currunt_employees[i]==0){
                companies[company_id].currunt_employees[i]=exp_id;

            }

        }
        if(i==companies[company_id].currunt_employees.length){
            companies[company_id].currunt_employees.push(exp_id);
        }

    }
     


    constructor(){
        User storage dummy_user=employees.push();
        dummy_user.name="dummy";
        dummy_user.wallet_address=msg.sender;
        dummy_user.id=0;
        dummy_user.user_skills=new uint256[](0);
        dummy_user.user_work_experience=new uint[](0);
    }
     


     function approve_manager(uint256 employee_Id) public{
        //require(em);
     }


}