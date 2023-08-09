import React, {useContext} from 'react';
import { AiFillPlayCircle } from "react-icons/ai";
import {SiEthereum} from 'react-icons/si';
import {BsInfoCircle} from 'react-icons/bs';

import { TransactionsContext } from "../context/TransactionsContext.jsx";
import { Loader } from "./";
import {shortenedAddress} from '../utils/shortenAddress.js';

const commonStyles='min-h-[70px] sm:px-2 sm:min-w-[120px] flex justify-center items-center border-[0.5px] border-gray-400 text-sm font-light text-white';

const Input = ({placeholder, name, type, value, handleChange}) => (
    <input placeholder={placeholder} type={type} step="0.0001" value={value} onChange={(e) => handleChange(e, name)} className="my-2 w-full rounded-small p-2 outline-none bg-transperant text-white border-none text-small white-glassmorphism"></input>
)

const welcome = () => {
    const {connectWallet, currentAccount, formData, sendTransaction, handleChange, isLoading}=useContext(TransactionsContext);
    // console.log(value);

    const handleSubmit = (e) => {
        const {addressTo, amount, keyword, remark} = formData;
        e.preventDefault();
        if(!addressTo || !amount || !keyword || !remark){
            return;
        }
        sendTransaction();
    }

    const handleUser = (e) => {
        e.preventDefault();
        location.href="userform.html";
        // return;
    }

    return (
        <div className="flex w-full justify-center items-center">
            <div className="flex mf:flex-row flex-col items-start justify-between md:p-20 py-12 px-4">
                <div className="flex flex-1 justify-start flex-col mf:mr-10">
                    <h1 className="text-2xl sm:text-5xl text-white text-gradient py-1">
                        Send Challan <br /> hassle-free
                    </h1>
                    <p className="text-left mt-5 text-white font-light md: w-9/12 w-11/12 text-base">
                        Experience the newest way to pay your Challan quickly and securely
                    </p>
                    {!currentAccount && (<button
                        type="button"
                        onClick={connectWallet}
                        className='flex flex-row justify-center items-center my-5 bg-[#7dd2c6] p-3 rounded-full cursor-pointer hover:bg-[#2546bd]'>
                        <p className="text-white text-base font-semibold">Connect Wallet</p>
                    </button>)}
                    <button
                        type="button"
                        onClick={handleUser}
                        className='flex flex-row justify-center items-center my-5 bg-[#7dd2c6] p-3 rounded-full cursor-pointer hover:bg-[#2546bd]'>
                        <p className="text-white text-base font-semibold">Register User</p>
                    </button>
                    <div className="grid sm:grid-cols-3 grid-cols-2 w-full mt-10">
                        <div className={`rounded-tl-2xl ${commonStyles}`}>Reliability</div>
                        <div className={commonStyles}>Security</div>
                        <div className={`rounded-tr-2xl ${commonStyles}`}>Ethereum</div>
                        <div className={`rounded-bl-2xl ${commonStyles}`}>Web 3.0</div>
                        <div className={`${commonStyles}`}>Low Fees</div>
                        <div className={`rounded-br-2xl ${commonStyles}`}>E-Challan</div>
                    </div>
                </div>
                <div className="flex flex-col flex-1 items-center justify-start w-full mf:mt-0 mt-20">
                    {/* <div className="p-3 justify-end items-start felx-col rounded-xl h-40 sm:w-72 w-fullmy-5 eth-card white-glassmorphism"> */}
                        <div className="flex justify-between flex-col w-full h-full ">
                            <div className="flex justify-between items-start">
                                <div className="w-20 h-20 rounded-full border-2 border-white flex justify-center items-center">
                                    <SiEthereum fontSize={40} color="#fff" />
                                </div>
                                {/* <BsInfoCircle fontSize={17} color="#fff" /> */}
                            </div>
                            <div>
                                <p className="text-white font-light">
                                    {/* render the address of the blockchain wallet connected to the application */}
                                    Connected Account:
                                    {shortenedAddress(currentAccount)}
                                </p>
                                {/* <p className="text-white font-semibold text-lg mt-1"> */}
                                    {/* render the address of the blockchain wallet connected to the application */}
                                    {/* Ethereum */}
                                {/* </p> */}
                            </div>
                        {/* </div> */}
                    </div>
                    <div className="p-5 sm:w-100 w-full flex flex-col justify-start items-center blue-glassmorphism">
                        <Input placeholder="Address To" name='addressTo' type="text" handleChange={handleChange} />
                        <Input placeholder="Amount in Ether" name='amount' type="number" handleChange={handleChange} />
                        <Input placeholder="Keyword (GIF)" name='keyword' type="text" handleChange={handleChange} />
                        <Input placeholder="Enter Remark" name='remark' type="text" handleChange={handleChange} />

                        <div className="h-[1px] w-full bg-gray-400 my-1" />
                            {isLoading ? (
                                <Loader />
                            ) : (
                                <button type="button" onClick={handleSubmit} className="text-white w-full mt-1 border-[1px] p-2 border-[#3d4f7c] hover: bg-[#7dd2c6 ] rounded-full cursor-pointer">Send Now</button>
                            )}
                    </div>
                </div>
            </div>
        </div>
    );
}

export default welcome;