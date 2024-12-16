// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract Certi{

    struct Certificate{
        // uint16 id;
        string name;
        string course;
        string grade;
        string date;
    }

    address admin;

    constructor(){
        admin = msg.sender;
    }

    mapping (uint16 => Certificate) public Cert;

    modifier OnlyAdmin{
        require(msg.sender == admin, "Unauthorised access");
        _;
    }

    

    function issueCertificate( uint16 _id, string memory _name, string memory _course, string memory _grade, string memory _date) public OnlyAdmin {
        require( bytes(Cert[_id].name).length == 0 , "Already existed");
        Cert[_id] = Certificate(_name,_course,_grade,_date);
    }
}
