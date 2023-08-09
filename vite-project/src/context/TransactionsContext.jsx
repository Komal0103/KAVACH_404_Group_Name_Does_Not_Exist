import React, {useEffect, useState} from 'react';
import {ethers} from 'ethers';
import {contractABI, contractAddress} from '../utils/constants.js';

export const TransactionsContext=React.createContext();
const {ethereum}=window;

const getEthereumContract = () => {
    const provider = new ethers.BrowserProvider(window.ethereum);
    const signer = provider.getSigner();
    const transactionContract = new ethers.Contract(contractAddress, contractABI, provider);
    console.log({
        provider,
        signer,
        transactionContract
    });
    return transactionContract;
}

const sendEthereumContract = () => {
    const provider = new ethers.BrowserProvider(window.ethereum);
    const signer = provider.getSigner();
    const transactionContract = new ethers.Contract(contractAddress, contractABI, signer);
    console.log({
        provider,
        signer,
        transactionContract
    });
    return transactionContract;
}

export const TransactionProvider = ({children}) => {
    const [currentAccount, setCurrentAccount] = useState('');
    const [formData, setFormData] = useState({addressTo:'', amount:'', keyword:'', remark:''});
    const [isLoading, setIsLoading] = useState(false);
    const [transactionCount, setTransactionCount] = useState(localStorage.getItem('transactionCount'));
    const [transactions, setTransactions] = useState([]);

    // requires React knowledge
    const handleChange = (e, name) => {
        setFormData((prevState) => ({...prevState, [name]:e.target.value}));
    }

    const getAllTransactions = async () => {
        try{
            if (!window.ethereum) return alert("Please install MetaMask");
            const transactionContract = getEthereumContract();
            const availableTransactions=await transactionContract.getTransactions();
            console.log(availableTransactions);
            if (!availableTransactions) console.log("No Transactions");
            const structuredTransactions=availableTransactions.map((transaction) => ({
                addressTo: transaction.receiver,
                addressFrom: transaction.sender,
                timestamp: new Date(transaction.timestamp.toNumber()*1000).toLocaleString(),
                message: transaction.message,
                keyword: transaction.keyword,
                amount: parseInt(transaction.amount.toString(16))/(10**18)
            }));
            console.log(structuredTransactions);
            setTransactions(structuredTransactions);
        }catch(error){
            console.log(error);
            console.log("Ethereum is not present");
        }
    }
    
    const checkIfWalletIsConnected = async () => {
        try{
            if (!window.ethereum) return alert("Please install MetaMask");

            const account = await ethereum.request({method:'eth_accounts'});
            if(account.length){
                setCurrentAccount(account[1]);
                getAllTransactions();
            } else {
                console.log('No accounts found.')
            }
            console.log(account);
        } catch (error){
            console.log(error);
            throw new Error("No Ethereum Object");
        }
    }

    const checkIfTransactionsExist = async () => {
        try{
            const transactionContract = getEthereumContract();
            const currentTransactionCount = await transactionContract.getTransactionCount();
            window.localStorage.setItem("transactionCount", currentTransactionCount);
        }catch(error){
            console.log(error);
            throw new Error("No Ethereum Object Found")
        }
    }

    const connectWallet = async () => {
        try{
            if (!window.ethereum) return alert("Please install MetaMask");
            const account = await ethereum.request({method:'eth_requestAccounts', });
            window.localStorage.setItem("transactionCount", transactionCount);
            setCurrentAccount(account[0]);
        } catch(error){
            console.log(error);
            throw new Error("No Ethereum Object Found")
        }
    }
    
    const sendTransaction = async () => {
        try{
            if (!window.ethereum) return alert("Please install MetaMask");
            // get data from the form on the welcome section
            const TransactionContract = sendEthereumContract();
            const {addressTo, amount, keyword, remark} = formData;
            // const transactionContract = getEthereumContract();
            const parsedAmount=ethers.parseEther(amount);
            // console.log(amount);
            // console.log(parsedAmount._hex);

            await ethereum.request({
                method: 'eth_sendTransaction',
                params:[{
                    from: currentAccount,
                    to: addressTo,
                    gas: '0x5208', // always put hexadecimal number - 21000 GWEI
                    value: "0x" + (parsedAmount).toString(16), // needs to be in hex values
                }],
            });
            const transactionHash= await transactionContract.add(addressTo, parsedAmount, remark, keyword);
            setIsLoading(true);
            console.log(`Loading  ${transactionHash.hash}`);
            await transactionHash.wait();
            setIsLoading(false);
            console.log(`Success ${transactionHash.hash}`);
            const transactionCount = await TransactionContract.getTransactionCount();
            setTransactionCount(transactionCount.toNumber());
            window.location.reload();
        } catch(error) {
            console.log(error);
            throw new Error('No Ethereum Object.')
        }
    };
    
    useEffect(() => {
        checkIfWalletIsConnected();
        checkIfTransactionsExist();
    }, [transactionCount]);
    return(
        <TransactionsContext.Provider value={{transactionCount, connectWallet, currentAccount, formData, setFormData, handleChange, sendTransaction, transactions, isLoading}}>
            {children}
        </TransactionsContext.Provider>
    );
};