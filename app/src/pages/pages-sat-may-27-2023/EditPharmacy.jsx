import React, { useState, useEffect } from "react";
import axios from 'axios';
import { Link, useNavigate, useParams } from "react-router-dom";

import 'bootstrap/dist/css/bootstrap.css';
import "../styles/App.css";

import { useAddress, useContract, useContractWrite,  } from "@thirdweb-dev/react";

const EditPharmacy = () => {

  let navigate = useNavigate();
//   const { contract } = useContract("0x135B8F385f8FaE5ab558d2D2A7A5d33a99184485"); // 11.7 - Improved metadata and function callls (5/21/23)
  const { contract } = useContract("0xE5960C2422B192a54988D0b7d7cD6d3f8A3a7794"); // 12.1 - Improved metadata and hasPharmacyRole (5/23/23)
  const address = useAddress(); 

// From Part 4 (9:01): https://youtu.be/6DUx-WUsJro?t=541
  const { id } = useParams();

  // console.log('id check', id);

  // Add state (8:06): https://www.youtube.com/watch?v=Ovr1ewUIrpU&t
      const [pharmacy, setPharmacy] = useState({
          pharmacy_name: "",
          pharmacy_wallet: "",
          pharmacy_phone:"",
          pharmacy_fax:"",
          pharmacy_address:"",
          id:""
      });
  
    //   const [medication, setMedication] = useState([]);
    //   const [patients, setPatients] = useState([]);
      // const [medication, setMedication] = useState({
      //     name: "",
      //     sig: "",
      //     strength:"",
      //     quantity:""
      // });

    useEffect(()=> {    
        loadEditPharmacy(); 
        // getPharmacyRoleString();
        // loadMedications();
        // loadViewPharmacy();
    }, [])

      // const [name,wallet_address,email] = patient; // patient is not iterable nasty error
      const {pharmacy_name,pharmacy_wallet,pharmacy_phone,pharmacy_fax,pharmacy_address} = pharmacy; 
  
      const handleChange=(e)=>{
          setPharmacy({...pharmacy,[e.target.name]: e.target.value })
          // console.log(e);
          console.log(pharmacy);
      }
  
      const updateForm = async (e) => {
          e.preventDefault(); 
  
          console.log("Pharmacy Form Inside updateForm is:", pharmacy);
  
          await axios.post("https://rxminter.com/php-react/update-pharmacy.php", pharmacy).then((result)=>{
              console.log(result);

              if(result.data.status =='valid'){
                  navigate('/');
              }else{
                  alert('There is a problem saving this patient to the database. Please try again.');
              }
          });
      }

   

      // const loadUsers = async (id) => {  //id was not being passed in when passed in as a parameter (14:45) pt 4.
      const loadEditPharmacy = async () => {
          // console.log('ID check inside loadUsers', id) 
        //   setPharmacy({pharmacy_name: "", pharmacy_wallet: "", pharmacy_phone:"", pharmacy_fax: "", pharmacy_address:"", id:""});
          const result = await axios.get("https://rxminter.com/php-react/edit-pharmacy.php?id="+id);
          console.log("loadEditPharmacy fetched:", result);
          // setPatient(result.data.records);
          setPharmacy(result.data);
          // navigate('/');
      }


// 5:10pm R 5/4/23: Load all medications: 
    //   const loadMedications = async () => {
    //     setMedication([]);   
    //     const result = await axios.get("https://rxminter.com/php-react/viewmeds.php");
    //     console.log(result);
    //     setMedication(result.data.meds);
    //     // navigate('/');
    //   }

// Add Pharmacy Role - Added 5/22/23 
    const [pharmacyRole, setPharmacyRole] = useState('')

    const getPharmacyRoleString = async () => {
        try{
            console.log('pharmacy address passed to hasRolePharmacyString is:', pharmacy.pharmacy_wallet)
            const dataGetPharmacyRole = await contract.call("hasRolePharmacyString", [pharmacy.pharmacy_wallet]);
            setPharmacyRole(dataGetPharmacyRole)
            console.log('getPharmacyRoleString returned: ', dataGetPharmacyRole)
        }catch(err){
            console.error("contract call failure", err);
        }
    }    

    console.log('pharmacy address just outside of getPharmacyRoleString() is:', pharmacy.pharmacy_wallet)
    getPharmacyRoleString();


    const { mutateAsync: addPharmacy } = useContractWrite(contract, "addPharmacy")
    const addPharmacyRole = async (e) => {
        e.preventDefault();
      try {
        const dataAddPharmacyRole = await addPharmacy({ args: [pharmacy_wallet] });
                console.info("contract call successs", dataAddPharmacyRole);
                // setPatientRole(data) receipt.events[0].args.tokenId;
                console.log("Target Receipt Transaction:", dataAddPharmacyRole.receipt.events[0].getTransaction)
                console.log("Target Receipt Status:", dataAddPharmacyRole.receipt.status)
                // setPharmacyRole(dataAddPharmacyRole)
        getPharmacyRoleString()

      } catch (err) {
        console.error("contract call failure", err);
      }
    }


    const removePharmacyRole = async (e) => {
        e.preventDefault()
        try{
            const dataRemovePharmacy = await contract.call("removePharmacy", [pharmacy_wallet]);
            console.log('getPharmacyRoleString returned: ', dataRemovePharmacy)
            
            getPharmacyRoleString();
        }catch(err){
            console.error("contract call failure", err);
        }
    }



    // const loadViewPharmacy = async () => {
    //     // setPharmacy([]);   
    //     const result = await axios.get("https://rxminter.com/php-react/view-pharmacy.php");
    //     console.log(result);
    //     setPharmacy(result.data.records);
    //     // navigate('/');
    // }

    const handleHasPharmacyRoleString = (e) => {
        e.preventDefault();  
        // setShowFillButton('block')
        console.log('pharmacy address inside of onClick handler is:', pharmacy.pharmacy_wallet)
        getPharmacyRoleString();

      }

    //   const handleContinueWorking = (e) => {
    //     e.preventDefault();  
    //     setShowFillButton('block')
    //     setShowSendButton('none')
    //     inputPillsFilled.current.value = '';
    //     inputDateFilled.current.value = currentDate;
    //     navigate(`/pharmacy-review-nft/${id}`)
    //   }




  return (

<>
        <form onSubmit={e => updateForm(e)}>
                <div className="nft_box_size">
                        <div className="row">
                            <div className="col-md-12 text-center">
                                <h1>Edit Pharmacy: {pharmacy_name}</h1>                                       
                            </div>
                </div>

                <div className="box_size">
                        <div className="row">
                                <div className="col-md-2">Name:</div>
                                <div className="col-md-10">
                                    <input type="text" name="pharmacy_name" className="form-control" value={pharmacy_name} onChange={(e) => handleChange(e)} />   
                                </div>
                        </div>



                            <div className="row">
                                    <div className="col-md-2">Wallet:</div>
                                    <div className="col-md-10">
                                        <input type="text" name="pharmacy_wallet" className="form-control" value={pharmacy_wallet} onChange={(e) => handleChange(e)} />   
                                    </div>
                            </div>

                            <div className="row">
                                    <div className="col-md-2">Phone:</div>
                                    <div className="col-md-10">
                                        <input type="text" name="pharmacy_phone" className="form-control" value={pharmacy_phone} onChange={(e) => handleChange(e)} />   
                                    </div>
                            </div>

                            <div className="row">
                                    <div className="col-md-2">Fax:</div>
                                    <div className="col-md-10">
                                        <input type="text" name="pharmacy_fax" className="form-control" value={pharmacy_fax} onChange={(e) => handleChange(e)} />   
                                    </div>
                            </div>

                            <div className="row">
                                    <div className="col-md-2">Address:</div>
                                    <div className="col-md-10">
                                        <input type="text" name="pharmacy_address" className="form-control" value={pharmacy_address} onChange={(e) => handleChange(e)} />   
                                    </div>
                            </div>
                        
                            <div className="row">
                                <div className="col-md-12 text-center">
                                    {/* <input type="submit" name="submit" value="Add Patient" className="btn btn-warning" /> */}
                                    <button type="submit" className="btn btn-warning" >Save Changes To Pharmacy</button>

                                </div>
                            </div>
                    </div>
                </div>
        </form>


            <hr></hr>

            {pharmacyRole != "Pharmacy Role Assigned" ? (
                <>
                        <div className="nft_box_size">
                            <div className="row">
                                <div className="col-md-12 text-center">
                                    <h2>Manage Role: <b style={{color:"red"}}>{pharmacyRole}</b></h2>                                       
                                </div>
                            </div>
                        </div>

                        <br></br>
                    

                        <div className="box_size">
                                <div className="text-center">
                                    <button onClick={(e) => addPharmacyRole(e)} className="btn btn-success">Add Pharmacy Role to {pharmacy_name}</button>
                                </div>
                        </div>
                </>

            ) : (

                <>
                        <div className="nft_box_size">
                            <div className="row">
                                <div className="col-md-12 text-center">
                                    <h2>Manage Role: <b style={{color:"green"}}>{pharmacyRole}</b></h2>                                       
                                </div>
                            </div>
                        </div>
                    
                        <br></br>
                        
                        <div className="text-center">
                            <button onClick={(e) => removePharmacyRole(e)} className="btn btn-danger">Remove Patient Role for {pharmacy_name}</button>
                        </div>
                </>                
            )}
</>   

  )
}
export default EditPharmacy