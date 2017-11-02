pragma solidity ^0.4.15;

contract JuryVotes {

    //declare variables
    address public Owner;
    uint public ProcessJudged;       
    uint public NOneJudgedTotal;

    struct votejury {
        address jury;
        bool vote;
        bool voted;        
    }

    struct Judgment {    
        string occurrence;
        bool defendant;
        bool completed;                    
        mapping (uint => votejury) judges;
    }

    struct Person {
        uint numOneJudgments;
        mapping (uint => Judgment) Judgments;
    }

    
    mapping (address => Person) public people;

    event GetJudgmentUsuario(address _juryOne, address _juryTwo, address _juryThree, address _juryFour, address _juryFive, string _occurrence, bool _completed, bool _defendant);
        
    //set constructor
    function JuryVotes() {
        Owner = msg.sender;        
    }

    
    function InserirJudgment (
        address _judged,
        address _juryOne, 
        address _juryTwo, 
        address _juryThree, 
        address _juryFour, 
        address _juryFive,
        string _occurrence) public testOwner
        {
            require(_judged != 0x0);
            require(_juryOne != 0x00);
            require(_juryTwo != 0x0);
            require(_juryThree != 0x0);
            require(_juryFour != 0x0);
            require(_juryFive != 0x0);
            require(bytes(_occurrence).length > 0);

            uint nOneJudgmentjudged = 0;

            //testing if was created a process before
            if(people[_judged].numOneJudgments > 0) {
                nOneJudgmentjudged = people[_judged].numOneJudgments;
            } else {
                people[_judged] = Person(0);            
            }

            nOneJudgmentjudged = NOneJudgedTotal++;
           

            //Creates the structure necessary for a judgment
            Person storage p = people[_judged];
            p.numOneJudgments = nOneJudgmentjudged;
            p.Judgments[nOneJudgmentjudged] = Judgment(_occurrence,false,false); 

            //was defined five judge
            p.Judgments[nOneJudgmentjudged].judges[0].vote = false;
            p.Judgments[nOneJudgmentjudged].judges[0].voted = false;
            p.Judgments[nOneJudgmentjudged].judges[0].jury = _juryOne;

            p.Judgments[nOneJudgmentjudged].judges[1].vote = false;
            p.Judgments[nOneJudgmentjudged].judges[1].voted = false;
            p.Judgments[nOneJudgmentjudged].judges[1].jury = _juryTwo;

            p.Judgments[nOneJudgmentjudged].judges[2].vote = false;
            p.Judgments[nOneJudgmentjudged].judges[2].voted = false;
            p.Judgments[nOneJudgmentjudged].judges[2].jury = _juryThree;

            p.Judgments[nOneJudgmentjudged].judges[3].vote = false;
            p.Judgments[nOneJudgmentjudged].judges[3].voted = false;
            p.Judgments[nOneJudgmentjudged].judges[3].jury = _juryFour;

            p.Judgments[nOneJudgmentjudged].judges[4].vote = false;
            p.Judgments[nOneJudgmentjudged].judges[4].voted = false;
            p.Judgments[nOneJudgmentjudged].judges[4].jury = _juryFive;            
    }
   
    
    function getJudgmentUsuario(address _judged, uint _codJudgment) public returns (
        string _occurrence, 
        bool _defendant, 
        bool _completed, 
        address _juryOne, 
        address _juryTwo, 
        address _juryThree, 
        address _juryFour, 
        address _juryFive
        ) {        
        Person storage p = people[_judged];
        _occurrence = p.Judgments[_codJudgment].occurrence;
        _defendant = p.Judgments[_codJudgment].defendant;
        _completed = p.Judgments[_codJudgment].completed;
        _juryOne = p.Judgments[_codJudgment].judges[0].jury;
        _juryTwo = p.Judgments[_codJudgment].judges[1].jury;
        _juryThree = p.Judgments[_codJudgment].judges[2].jury;
        _juryFour = p.Judgments[_codJudgment].judges[3].jury;
        _juryFive = p.Judgments[_codJudgment].judges[4].jury; 

        GetJudgmentUsuario(_juryOne, _juryTwo, _juryThree, _juryFour, _juryFive, _occurrence, _completed, _defendant);
    }

    function Votar(address _judged, uint _codJudgment, bool _vote) public returns (bool completed) {
        bool juryTrue = false;
        uint juryNOneero = 0;

        //test variables
        require(_judged != 0x0);
        require(_codJudgment != 0);

        Person storage p = people[_judged];

        //Test if msg.Sender = Jury (or any five Jury)
        for (uint index = 0; index <= 6; index++) {
            if(p.Judgments[_codJudgment].judges[index].jury == msg.sender) {
                juryTrue = true;
                juryNOneero = --index;
            }           
            
        }

        require(juryTrue == true);
        require(p.Judgments[_codJudgment].judges[juryNOneero].voted == false);

        //update Vote
        p.Judgments[_codJudgment].judges[index].vote = _vote;
        p.Judgments[_codJudgment].judges[juryNOneero].voted = true;        

        return true;
    }

     modifier testOwner() {
        require(Owner == msg.sender);
        _;
    }
    
    
}