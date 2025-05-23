pragma solidity ^0.4.16;

contract Ethraffle_v4b {
    struct Contestant {
        address addr;
        uint raffleId;
    }

    event RaffleResult(
        uint raffleId,
        uint winningNumber,
        address winningAddress,
        address seed1,
        address seed2,
        uint seed3,
        bytes32 randHash
    );

    event TicketPurchase(
        uint raffleId,
        address contestant,
        uint number
    );

    event TicketRefund(
        uint raffleId,
        address contestant,
        uint number
    );

    uint public constant prize = 2.5 ether;
    uint public constant fee = 0.03 ether;
    uint public constant totalTickets = 50;
    uint public constant pricePerTicket = (prize + fee) / totalTickets; 
    address feeAddress;

    bool public paused = false;
    uint public raffleId = 1;

    uint public blockNumber = block.number;
    uint nextTicket = 0;
    mapping (uint => Contestant) contestants;
    uint[] gaps;

    function Ethraffle_v4b() public {
        feeAddress = msg.sender;
    }

    function () payable public {
        buyTickets();
    }

    function buyTickets() payable public {
        require(!paused, "Raffle is paused");
        
        uint moneySent = msg.value;

        while (moneySent >= pricePerTicket && nextTicket < totalTickets) {
            uint currTicket = 0;
            if (gaps.length > 0) {
                currTicket = gaps[gaps.length-1];
                gaps.length--;
            } else {
                currTicket = nextTicket++;
            }

            contestants[currTicket] = Contestant(msg.sender, raffleId);
            emit TicketPurchase(raffleId, msg.sender, currTicket);
            moneySent -= pricePerTicket;
        }

        if (nextTicket == totalTickets) {
            chooseWinner();
        }

        if (moneySent > 0) {
            msg.sender.transfer(moneySent);
        }
    }

    function chooseWinner() private {
        address seed1 = contestants[uint(block.coinbase) % totalTickets].addr;
        address seed2 = contestants[uint(msg.sender) % totalTickets].addr;
        uint seed3 = block.difficulty;
        bytes32 randHash = keccak256(abi.encode(seed1, seed2, seed3));

        uint winningNumber = uint(randHash) % totalTickets;
        address winningAddress = contestants[winningNumber].addr;
        emit RaffleResult(raffleId, winningNumber, winningAddress, seed1, seed2, seed3, randHash);

        raffleId++;
        nextTicket = 0;
        blockNumber = block.number;

        winningAddress.transfer(prize);
        feeAddress.transfer(fee);
    }

    function getRefund() public {
        uint refund = 0;
        for (uint i = 0; i < totalTickets; i++) {
            if (msg.sender == contestants[i].addr && raffleId == contestants[i].raffleId) {
                refund += pricePerTicket;
                contestants[i] = Contestant(address(0), 0);
                gaps.push(i);
                emit TicketRefund(raffleId, msg.sender, i);
            }
        }

        if (refund > 0) {
            msg.sender.transfer(refund);
        }
    }

    function endRaffle() public {
        require(msg.sender == feeAddress, "Only fee address can end raffle");
        
        paused = true;

        for (uint i = 0; i < totalTickets; i++) {
            if (raffleId == contestants[i].raffleId) {
                emit TicketRefund(raffleId, contestants[i].addr, i);
                contestants[i].addr.transfer(pricePerTicket);
            }
        }

        emit RaffleResult(raffleId, totalTickets, address(0), address(0), address(0), 0, 0);
        raffleId++;
        nextTicket = 0;
        blockNumber = block.number;
        gaps.length = 0;
    }

    function togglePause() public {
        require(msg.sender == feeAddress, "Only fee address can toggle pause");
        
        paused = !paused;
    }

    function kill() public {
        require(msg.sender == feeAddress, "Only fee address can kill contract");
        
        selfdestruct(feeAddress);
    }
}