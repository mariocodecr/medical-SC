use starknet::ContractAddress;

use snforge_std::{declare, ContractClassTrait, DeclareResultTrait};

use medical::IDoctorRankingDispatcher;
use medical::IDoctorRankingDispatcherTrait;

fn deploy_contract(name: ByteArray) -> ContractAddress {
    let contract = declare(name).unwrap().contract_class();
    let (contract_address, _) = contract.deploy(@ArrayTrait::new()).unwrap();
    contract_address
}

#[test]
fn test_increase_balance() {
    let contract_address = deploy_contract("DoctorRanking");

    let dispatcher = IDoctorRankingDispatcher { contract_address };

    let doctor_address: ContractAddress = 12345.try_into().unwrap(); // Example doctor address
    

    let balance_before = dispatcher.get_ranking(doctor_address);
    assert(balance_before == 0, 'Invalid balance');
    
    let rating_value: u8 = 9; // Example rating (between 1 and 10)
    
    dispatcher.rank_doctor(doctor_address, rating_value);

    let balance_after = dispatcher.get_ranking(doctor_address);
    assert(balance_after == 9, 'Invalid balance');

    
   
}
