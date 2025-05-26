use starknet::ContractAddress;
use starknet::storage::*;

// Define the contract interface
#[starknet::interface]
pub trait IDoctorRanking<TContractState> {
    /// Submit or update the ranking for a doctor.
    /// # Arguments
    /// * `doctor` - The ContractAddress of the doctor being ranked.
    /// * `rating` - The rating given to the doctor (1-10).
    fn rank_doctor(ref self: TContractState, doctor: ContractAddress, rating: u8);

    /// Retrieve the current ranking for a doctor.
    /// # Arguments
    /// * `doctor` - The ContractAddress of the doctor whose ranking is requested.
    /// # Returns
    /// The current rating of the doctor. Returns 0 if no rating has been submitted.
    fn get_ranking(self: @TContractState, doctor: ContractAddress) -> u8;
}

// Define the contract module
#[starknet::contract]
pub mod DoctorRanking {
    use starknet::ContractAddress;
    use starknet::storage::*;
    
    // Define storage variables
    #[storage]
    pub struct Storage {
        // A mapping to store the latest rating for each doctor address.
        // The key is the doctor's ContractAddress, and the value is their rating (1-10).
        doctor_ratings: Map<ContractAddress, u8>,
    }

    // Implement the contract interface
    // Functions defined here are public and callable from outside the contract
    #[abi(embed_v0)]
    pub impl DoctorRankingImpl of super::IDoctorRanking<ContractState> {
        // Function to submit a ranking for a doctor
        fn rank_doctor(ref self: ContractState, doctor: ContractAddress, rating: u8) {
            // Validate that the rating is within the acceptable range (1-10)
            assert(rating >= 1, 'Rating must be >= 1');
            assert(rating <= 10, 'Rating must be <= 10');

            // Write the rating to the doctor_ratings mapping.
            // This will overwrite any previous rating for this doctor.
            self.doctor_ratings.write(doctor, rating);
        }

        // Function to get the ranking for a doctor
        fn get_ranking(self: @ContractState, doctor: ContractAddress) -> u8 {
            // Read the rating from the doctor_ratings mapping.
            // If no entry exists for the doctor, it will return the default value for u8, which is 0.
            self.doctor_ratings.read(doctor)
        }
    }
}