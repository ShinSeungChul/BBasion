pragma solidity ^0.5.11;


contract BBasion {


    // number of total Tokens
    uint private nTokens;

    // Genesis Owner
    address private owner;

    // Token owner => Balance
    mapping (address => uint) private TokenBalance;

    // Post Identifier => Post Owner
    mapping(uint => address) poster;

    // Post Owner => Post count
    mapping(address => uint) postNum;

    // Review Identifier => Review Owner
    mapping(uint => address) reviewer;

    // Constructor
    constructor(uint initialTokens) public {
        nTokens = initialTokens;
        owner = msg.sender;
        TokenBalance[owner] = initialTokens;
    }


    // Token Base gives token to user
    function base_Transfer(address target) public returns (bool) {
        require(TokenBalance[owner] >= 1, "Not Enough Minerals : please Increase Total Tokens");
        TokenBalance[target] += 1;
        TokenBalance[owner] -= 1;
        return true;
    }


    // Token Base gives token to Shop owner
    function base_M_Transfer(address target, uint amountT) public returns (bool) {
        require(TokenBalance[owner] - amountT >= 0, "Not Enough Minerals : please Increase Total Tokens");
        TokenBalance[target] += amountT;
        TokenBalance[owner] -= amountT;
        return true;
    }


    // single Token transfer between users
    function single_Transfer(address target, address sender) public returns (bool) {
        require(TokenBalance[sender] >= 1, "Not Enough Minerals : Sernder has not enough Tokens");
        TokenBalance[target] += 1;
        TokenBalance[sender] -= 1;
        return true;
    }


    // multi Token transfer between users
    function multi_Transfer(address target, address sender, uint amountT) public returns (bool) {
        require(TokenBalance[sender] - amountT >= 0, "Not Enough Minerals : Sernder has not enough Tokens");
        TokenBalance[target] += amountT;
        TokenBalance[sender] -= amountT;
        return true;
    }


    // get total Token numbers
    function getTotalTokens() public view returns (uint) {
        return nTokens;
    }


    // get Token balance of a specific user
    function getBalanceToken() public view returns (uint) {
        return TokenBalance[msg.sender];
    }


    // create Token account for a new user
    function CreateAccount() public returns (bool){
        TokenBalance[msg.sender] = 0;
        return true;
    }


    // create Token account for a new user
    function IncreaseTotalTokens(uint amount) public returns (bool){
        TokenBalance[owner] += amount;
        nTokens += amount;
        return true;
    }


    // Burn Tokens
    function _BurnTokens(uint amount) private{
        require(TokenBalance[owner] - amount > 1, "Not Enough Tokens to burn");
        require(nTokens - amount > 1, "U Cant Do So : total Tokens < Tokens to burn");
        nTokens -= amount;
        TokenBalance[owner] = 0;
    }


    // JESSI - Registor post of product
    function regist(uint _productNum) public {
        require(TokenBalance[msg.sender] >= 1, "Not Enough Minerals : Sernder has not enough Tokens");
        poster[_productNum] = msg.sender;
        postNum[msg.sender]++;
        TokenBalance[msg.sender] -= 1;
        TokenBalance[owner]++;
    }


    // delete Registored product post
    function delRegist(uint _productNum) public {
        require(msg.sender == poster[_productNum], "U already posted product post");
        postNum[msg.sender]--;
        delete poster[_productNum];
    }


    // When Review Posted
    function review(uint _postNum) public {
        require(postNum[msg.sender] == 0, "U already posted a review");
        reviewer[_postNum] = msg.sender;
        TokenBalance[msg.sender]++;
        TokenBalance[owner]--;
        base_Transfer(msg.sender);
    }


    // get Product Post Owner
    function getPostOwner(uint _productNum) public view returns (address){
        return poster[_productNum];
    }


    // get Review Owner
    function getReviewOwner(uint _reviewNum) public view returns (address){
        return reviewer[_reviewNum];
    }


    // End of Contract
}