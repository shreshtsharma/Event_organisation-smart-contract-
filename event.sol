//SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 <0.9.0;

contract EventOganisation
{
    struct events{
        address organiser;
        string name;
        uint ticketcount;
        uint ticketremaining;
        uint price;
        uint date;
    }
    mapping (uint=>events) public Event;
    mapping (address=>mapping(uint=>uint)) public tickets;
    uint public nextId;
    function createEvent(string memory _name,uint date,uint ticket,uint price) public
    {
        require(date>block.timestamp,"TIME ERROR!!");
        require(ticket>0);
        Event[nextId]=events(msg.sender,_name,ticket,ticket,price,date);
        nextId++;
    }
    function buytickets(uint id,uint quantity) external payable
    {
        require(Event[id].date!=0,"event does not exists");
        require(Event[id].date>block.timestamp,"event has already occured");
        require(Event[id].ticketremaining>=quantity,"tickets not available");
        events storage _event=Event[id];
        require (msg.value==(_event.price*quantity),"ether is not enough");
        Event[id].ticketremaining-=quantity;
        tickets[msg.sender][id]+=quantity;

    } 
    function transfertickets(uint id,address receiver,uint quantity) public
    {
        require(Event[id].date!=0,"event does not exists");
        require(Event[id].date>block.timestamp,"event has already occured");
        require(tickets[msg.sender][id]>=quantity,"do not have enough tickets");
        tickets[msg.sender][id]-=quantity;
        tickets[receiver][id]+=quantity;
    }
}