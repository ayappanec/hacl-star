module Spec.Blake2.Incremental.Test

#reset-options "--z3rlimit 100 --max_fuel 0"

open FStar.Mul
open Lib.IntTypes
open Lib.RawIntTypes
open Lib.Sequence
open Lib.ByteSequence

open Spec.Blake2.Incremental

//
// Test 1
//

let test1_plaintext_list  = List.Tot.map u8_from_UInt8 [
  0x61uy; 0x62uy; 0x63uy
]
let test1_plaintext : lbytes 3 =
  assert_norm (List.Tot.length test1_plaintext_list = 3);
  of_list test1_plaintext_list

let test1_key_list = List.Tot.map u8_from_UInt8 []

let test1_key : lbytes 32 =
  assert_norm (List.Tot.length test1_key_list = 0);
  of_list test1_key_list

let test1_expected_list = List.Tot.map u8_from_UInt8 [
  0x50uy; 0x8Cuy; 0x5Euy; 0x8Cuy; 0x32uy; 0x7Cuy; 0x14uy; 0xE2uy;
  0xE1uy; 0xA7uy; 0x2Buy; 0xA3uy; 0x4Euy; 0xEBuy; 0x45uy; 0x2Fuy;
  0x37uy; 0x45uy; 0x8Buy; 0x20uy; 0x9Euy; 0xD6uy; 0x3Auy; 0x29uy;
  0x4Duy; 0x99uy; 0x9Buy; 0x4Cuy; 0x86uy; 0x67uy; 0x59uy; 0x82uy;
]
let test1_expected : lbytes 32 =
  assert_norm (List.Tot.length test1_expected_list = 32);
  of_list test1_expected_list



let test2_plaintext_list = List.Tot.map u8_from_UInt8 [ 0x00uy ]
let test2_plaintext : lbytes 1 =
  assert_norm (List.Tot.length test2_plaintext_list = 1);
  of_list test2_plaintext_list

let test2_key_list = List.Tot.map u8_from_UInt8 [
  0x00uy; 0x01uy; 0x02uy; 0x03uy; 0x04uy; 0x05uy; 0x06uy; 0x07uy;
  0x08uy; 0x09uy; 0x0auy; 0x0buy; 0x0cuy; 0x0duy; 0x0euy; 0x0fuy;
  0x10uy; 0x11uy; 0x12uy; 0x13uy; 0x14uy; 0x15uy; 0x16uy; 0x17uy;
  0x18uy; 0x19uy; 0x1auy; 0x1buy; 0x1cuy; 0x1duy; 0x1euy; 0x1fuy ]

let test2_key : lbytes 32 =
  assert_norm (List.Tot.length test2_key_list = 32);
  of_list test2_key_list

let test2_expected_list = List.Tot.map u8_from_UInt8 [
  0x40uy; 0xd1uy; 0x5fuy; 0xeeuy; 0x7cuy; 0x32uy; 0x88uy; 0x30uy;
  0x16uy; 0x6auy; 0xc3uy; 0xf9uy; 0x18uy; 0x65uy; 0x0fuy; 0x80uy;
  0x7euy; 0x7euy; 0x01uy; 0xe1uy; 0x77uy; 0x25uy; 0x8cuy; 0xdcuy;
  0x0auy; 0x39uy; 0xb1uy; 0x1fuy; 0x59uy; 0x80uy; 0x66uy; 0xf1uy ]

let test2_expected : lbytes 32 =
  assert_norm (List.Tot.length test2_expected_list = 32);
  of_list test2_expected_list



let test3_plaintext_list = List.Tot.map u8_from_UInt8 [
  0x00uy; 0x01uy; 0x02uy; 0x03uy; 0x04uy; 0x05uy; 0x06uy; 0x07uy;
  0x08uy; 0x09uy; 0x0auy; 0x0buy; 0x0cuy; 0x0duy; 0x0euy; 0x0fuy;
  0x10uy; 0x11uy; 0x12uy; 0x13uy; 0x14uy; 0x15uy; 0x16uy; 0x17uy;
  0x18uy; 0x19uy; 0x1auy; 0x1buy; 0x1cuy; 0x1duy; 0x1euy; 0x1fuy;
  0x20uy; 0x21uy; 0x22uy; 0x23uy; 0x24uy; 0x25uy; 0x26uy; 0x27uy;
  0x28uy; 0x29uy; 0x2auy; 0x2buy; 0x2cuy; 0x2duy; 0x2euy; 0x2fuy;
  0x30uy; 0x31uy; 0x32uy; 0x33uy; 0x34uy; 0x35uy; 0x36uy; 0x37uy;
  0x38uy; 0x39uy; 0x3auy; 0x3buy; 0x3cuy; 0x3duy; 0x3euy; 0x3fuy;
  0x40uy; 0x41uy; 0x42uy; 0x43uy; 0x44uy; 0x45uy; 0x46uy; 0x47uy;
  0x48uy; 0x49uy; 0x4auy; 0x4buy; 0x4cuy; 0x4duy; 0x4euy; 0x4fuy;
  0x50uy; 0x51uy; 0x52uy; 0x53uy; 0x54uy; 0x55uy; 0x56uy; 0x57uy;
  0x58uy; 0x59uy; 0x5auy; 0x5buy; 0x5cuy; 0x5duy; 0x5euy; 0x5fuy;
  0x60uy; 0x61uy; 0x62uy; 0x63uy; 0x64uy; 0x65uy; 0x66uy; 0x67uy;
  0x68uy; 0x69uy; 0x6auy; 0x6buy; 0x6cuy; 0x6duy; 0x6euy; 0x6fuy;
  0x70uy; 0x71uy; 0x72uy; 0x73uy; 0x74uy; 0x75uy; 0x76uy; 0x77uy;
  0x78uy; 0x79uy; 0x7auy; 0x7buy; 0x7cuy; 0x7duy; 0x7euy; 0x7fuy;
  0x80uy; 0x81uy; 0x82uy; 0x83uy; 0x84uy; 0x85uy; 0x86uy; 0x87uy;
  0x88uy; 0x89uy; 0x8auy; 0x8buy; 0x8cuy; 0x8duy; 0x8euy; 0x8fuy;
  0x90uy; 0x91uy; 0x92uy; 0x93uy; 0x94uy; 0x95uy; 0x96uy; 0x97uy;
  0x98uy; 0x99uy; 0x9auy; 0x9buy; 0x9cuy; 0x9duy; 0x9euy; 0x9fuy;
  0xa0uy; 0xa1uy; 0xa2uy; 0xa3uy; 0xa4uy; 0xa5uy; 0xa6uy; 0xa7uy;
  0xa8uy; 0xa9uy; 0xaauy; 0xabuy; 0xacuy; 0xaduy; 0xaeuy; 0xafuy;
  0xb0uy; 0xb1uy; 0xb2uy; 0xb3uy; 0xb4uy; 0xb5uy; 0xb6uy; 0xb7uy;
  0xb8uy; 0xb9uy; 0xbauy; 0xbbuy; 0xbcuy; 0xbduy; 0xbeuy; 0xbfuy;
  0xc0uy; 0xc1uy; 0xc2uy; 0xc3uy; 0xc4uy; 0xc5uy; 0xc6uy; 0xc7uy;
  0xc8uy; 0xc9uy; 0xcauy; 0xcbuy; 0xccuy; 0xcduy; 0xceuy; 0xcfuy;
  0xd0uy; 0xd1uy; 0xd2uy; 0xd3uy; 0xd4uy; 0xd5uy; 0xd6uy; 0xd7uy;
  0xd8uy; 0xd9uy; 0xdauy; 0xdbuy; 0xdcuy; 0xdduy; 0xdeuy; 0xdfuy;
  0xe0uy; 0xe1uy; 0xe2uy; 0xe3uy; 0xe4uy; 0xe5uy; 0xe6uy; 0xe7uy;
  0xe8uy; 0xe9uy; 0xeauy; 0xebuy; 0xecuy; 0xeduy; 0xeeuy; 0xefuy;
  0xf0uy; 0xf1uy; 0xf2uy; 0xf3uy; 0xf4uy; 0xf5uy; 0xf6uy; 0xf7uy;
  0xf8uy; 0xf9uy; 0xfauy; 0xfbuy; 0xfcuy; 0xfduy; 0xfeuy
]

let test3_plaintext : lbytes (List.Tot.length test3_plaintext_list) =
  assert_norm (List.Tot.length test3_plaintext_list = 255);
  of_list test3_plaintext_list

let test3_key_list = List.Tot.map u8_from_UInt8 [
  0x00uy; 0x01uy; 0x02uy; 0x03uy; 0x04uy; 0x05uy; 0x06uy; 0x07uy;
  0x08uy; 0x09uy; 0x0auy; 0x0buy; 0x0cuy; 0x0duy; 0x0euy; 0x0fuy;
  0x10uy; 0x11uy; 0x12uy; 0x13uy; 0x14uy; 0x15uy; 0x16uy; 0x17uy;
  0x18uy; 0x19uy; 0x1auy; 0x1buy; 0x1cuy; 0x1duy; 0x1euy; 0x1fuy ]

let test3_key : lbytes 32 =
  assert_norm (List.Tot.length test3_key_list = 32);
  of_list test3_key_list

let test3_expected_list = List.Tot.map u8_from_UInt8 [
  0x3fuy; 0xb7uy; 0x35uy; 0x06uy; 0x1auy; 0xbcuy; 0x51uy; 0x9duy;
  0xfeuy; 0x97uy; 0x9euy; 0x54uy; 0xc1uy; 0xeeuy; 0x5buy; 0xfauy;
  0xd0uy; 0xa9uy; 0xd8uy; 0x58uy; 0xb3uy; 0x31uy; 0x5buy; 0xaduy;
  0x34uy; 0xbduy; 0xe9uy; 0x99uy; 0xefuy; 0xd7uy; 0x24uy; 0xdduy ]

let test3_expected : lbytes 32 =
  assert_norm (List.Tot.length test3_expected_list = 32);
  of_list test3_expected_list



let test4_plaintext_list = List.Tot.map u8_from_UInt8 [
  0x00uy; 0x01uy; 0x02uy; 0x03uy; 0x04uy; 0x05uy; 0x06uy; 0x07uy;
  0x08uy; 0x09uy; 0x0auy; 0x0buy; 0x0cuy; 0x0duy; 0x0euy; 0x0fuy;
  0x10uy; 0x11uy; 0x12uy; 0x13uy; 0x14uy; 0x15uy; 0x16uy; 0x17uy;
  0x18uy; 0x19uy; 0x1auy; 0x1buy; 0x1cuy; 0x1duy; 0x1euy; 0x1fuy;
  0x20uy; 0x21uy; 0x22uy; 0x23uy; 0x24uy; 0x25uy; 0x26uy; 0x27uy;
  0x28uy; 0x29uy; 0x2auy; 0x2buy; 0x2cuy; 0x2duy; 0x2euy; 0x2fuy;
  0x30uy; 0x31uy; 0x32uy; 0x33uy; 0x34uy; 0x35uy; 0x36uy; 0x37uy;
  0x38uy; 0x39uy; 0x3auy; 0x3buy; 0x3cuy; 0x3duy; 0x3euy; 0x3fuy;
  0x40uy; 0x41uy; 0x42uy; 0x43uy; 0x44uy; 0x45uy; 0x46uy; 0x47uy;
  0x48uy; 0x49uy; 0x4auy; 0x4buy; 0x4cuy; 0x4duy; 0x4euy; 0x4fuy;
  0x50uy; 0x51uy; 0x52uy; 0x53uy; 0x54uy; 0x55uy; 0x56uy; 0x57uy;
  0x58uy; 0x59uy; 0x5auy; 0x5buy; 0x5cuy; 0x5duy; 0x5euy; 0x5fuy;
  0x60uy; 0x61uy; 0x62uy; 0x63uy; 0x64uy; 0x65uy; 0x66uy; 0x67uy;
  0x68uy; 0x69uy; 0x6auy; 0x6buy; 0x6cuy; 0x6duy; 0x6euy; 0x6fuy;
  0x70uy; 0x71uy; 0x72uy; 0x73uy; 0x74uy; 0x75uy; 0x76uy; 0x77uy;
  0x78uy; 0x79uy; 0x7auy; 0x7buy; 0x7cuy; 0x7duy; 0x7euy; 0x7fuy;
  0x80uy; 0x81uy; 0x82uy; 0x83uy; 0x84uy; 0x85uy; 0x86uy; 0x87uy;
  0x88uy; 0x89uy; 0x8auy; 0x8buy; 0x8cuy; 0x8duy; 0x8euy; 0x8fuy;
  0x90uy; 0x91uy; 0x92uy; 0x93uy; 0x94uy; 0x95uy; 0x96uy; 0x97uy;
  0x98uy; 0x99uy; 0x9auy; 0x9buy; 0x9cuy; 0x9duy; 0x9euy; 0x9fuy;
  0xa0uy; 0xa1uy; 0xa2uy; 0xa3uy; 0xa4uy; 0xa5uy; 0xa6uy; 0xa7uy;
  0xa8uy; 0xa9uy; 0xaauy; 0xabuy; 0xacuy; 0xaduy; 0xaeuy; 0xafuy;
  0xb0uy; 0xb1uy; 0xb2uy; 0xb3uy; 0xb4uy; 0xb5uy; 0xb6uy; 0xb7uy;
  0xb8uy; 0xb9uy; 0xbauy; 0xbbuy; 0xbcuy; 0xbduy; 0xbeuy; 0xbfuy;
  0xc0uy; 0xc1uy; 0xc2uy; 0xc3uy; 0xc4uy; 0xc5uy; 0xc6uy; 0xc7uy;
  0xc8uy; 0xc9uy; 0xcauy; 0xcbuy; 0xccuy; 0xcduy; 0xceuy; 0xcfuy;
  0xd0uy; 0xd1uy; 0xd2uy; 0xd3uy; 0xd4uy; 0xd5uy; 0xd6uy; 0xd7uy;
  0xd8uy; 0xd9uy; 0xdauy; 0xdbuy; 0xdcuy; 0xdduy; 0xdeuy; 0xdfuy;
  0xe0uy; 0xe1uy; 0xe2uy; 0xe3uy; 0xe4uy; 0xe5uy; 0xe6uy; 0xe7uy;
  0xe8uy; 0xe9uy; 0xeauy; 0xebuy; 0xecuy; 0xeduy; 0xeeuy; 0xefuy;
  0xf0uy; 0xf1uy; 0xf2uy; 0xf3uy; 0xf4uy; 0xf5uy; 0xf6uy; 0xf7uy;
  0xf8uy; 0xf9uy; 0xfauy
]

let test4_plaintext : lbytes (List.Tot.length test4_plaintext_list) =
  assert_norm (List.Tot.length test4_plaintext_list = 251);
  of_list test4_plaintext_list

let test4_key_list = List.Tot.map u8_from_UInt8 [
  0x00uy; 0x01uy; 0x02uy; 0x03uy; 0x04uy; 0x05uy; 0x06uy; 0x07uy;
  0x08uy; 0x09uy; 0x0auy; 0x0buy; 0x0cuy; 0x0duy; 0x0euy; 0x0fuy;
  0x10uy; 0x11uy; 0x12uy; 0x13uy; 0x14uy; 0x15uy; 0x16uy; 0x17uy;
  0x18uy; 0x19uy; 0x1auy; 0x1buy; 0x1cuy; 0x1duy; 0x1euy; 0x1fuy ]

let test4_key : lbytes 32 =
  assert_norm (List.Tot.length test4_key_list = 32);
  of_list test4_key_list

let test4_expected_list = List.Tot.map u8_from_UInt8 [
  0xd1uy; 0x2buy; 0xf3uy; 0x73uy; 0x2euy; 0xf4uy; 0xafuy; 0x5cuy;
  0x22uy; 0xfauy; 0x90uy; 0x35uy; 0x6auy; 0xf8uy; 0xfcuy; 0x50uy;
  0xfcuy; 0xb4uy; 0x0fuy; 0x8fuy; 0x2euy; 0xa5uy; 0xc8uy; 0x59uy;
  0x47uy; 0x37uy; 0xa3uy; 0xb3uy; 0xd5uy; 0xabuy; 0xdbuy; 0xd7uy
]

let test4_expected : lbytes 32 =
  assert_norm (List.Tot.length test4_expected_list = 32);
  of_list test4_expected_list







//
// Test 5 BLAKE 2B
//

let test5_plaintext_list  = List.Tot.map u8_from_UInt8 [
  0x61uy; 0x62uy; 0x63uy
]
let test5_plaintext : lbytes 3 =
  assert_norm (List.Tot.length test5_plaintext_list = 3);
  of_list test5_plaintext_list

let test5_key_list = List.Tot.map u8_from_UInt8 []

let test5_key : lbytes 32 =
  assert_norm (List.Tot.length test5_key_list = 0);
  of_list test5_key_list

let test5_expected_list = List.Tot.map u8_from_UInt8 [
  0xBAuy; 0x80uy; 0xA5uy; 0x3Fuy; 0x98uy; 0x1Cuy; 0x4Duy; 0x0Duy; 0x6Auy; 0x27uy; 0x97uy; 0xB6uy; 0x9Fuy; 0x12uy; 0xF6uy; 0xE9uy;
  0x4Cuy; 0x21uy; 0x2Fuy; 0x14uy; 0x68uy; 0x5Auy; 0xC4uy; 0xB7uy; 0x4Buy; 0x12uy; 0xBBuy; 0x6Fuy; 0xDBuy; 0xFFuy; 0xA2uy; 0xD1uy;
  0x7Duy; 0x87uy; 0xC5uy; 0x39uy; 0x2Auy; 0xABuy; 0x79uy; 0x2Duy; 0xC2uy; 0x52uy; 0xD5uy; 0xDEuy; 0x45uy; 0x33uy; 0xCCuy; 0x95uy;
  0x18uy; 0xD3uy; 0x8Auy; 0xA8uy; 0xDBuy; 0xF1uy; 0x92uy; 0x5Auy; 0xB9uy; 0x23uy; 0x86uy; 0xEDuy; 0xD4uy; 0x00uy; 0x99uy; 0x23uy
]
let test5_expected : lbytes 64 =
  assert_norm (List.Tot.length test5_expected_list = 64);
  of_list test5_expected_list


//
// Main
//

val test_blake2: label:string -> a:Spec.Blake2.alg -> expected:bytes -> d:bytes -> k:bytes -> FStar.All.ML bool
let test_blake2 label a expected d k =

  IO.print_newline ();
  IO.print_newline ();
  IO.print_string label;

  let nn = length expected in

  let computed_simple : lbytes nn =
    Spec.Blake2.blake2 a d (length k) k nn
  in
  let computed_incr0 : lbytes nn =
    match Spec.Blake2.Incremental.blake2_incremental a d k nn with
    | None -> create nn (u8 0)
    | Some r -> r
  in
  let computed_incr1 : lbytes nn =
    let st: Spec.Blake2.Incremental.state_r a = Spec.Blake2.Incremental.blake2_incremental_init a k nn in
    match Spec.Blake2.Incremental.blake2_incremental_update a d st with
    | None -> create nn (u8 0)
    | Some st -> Spec.Blake2.Incremental.blake2_incremental_finish a st nn
  in
  let computed_incr2 : lbytes nn =
    let d_sub1 = sub #uint8 #(length d) d 0 (length d / 2) in
    let d_sub2 = sub #uint8 #(length d) d (length d / 2) (length d - (length d / 2)) in
    let st: Spec.Blake2.Incremental.state_r a = Spec.Blake2.Incremental.blake2_incremental_init a k nn in
    match Spec.Blake2.Incremental.blake2_incremental_update a d_sub1 st with
    | None -> create nn (u8 0)
    | Some st ->
    match Spec.Blake2.Incremental.blake2_incremental_update a d_sub2 st with
    | None -> create nn (u8 0)
    | Some st -> Spec.Blake2.Incremental.blake2_incremental_finish a st nn
  in

  let (&&) = (&&) in

  let result =
    Lib.PrintSequence.print_label_compare_display true "Not Incremental" nn expected computed_simple in

  let result = result &&
    Lib.PrintSequence.print_label_compare_display true "Incremental 0" nn expected computed_incr0 in

  let result = result &&
    Lib.PrintSequence.print_label_compare_display true "Incremental 1" nn expected computed_incr1 in

  let result = result &&
    Lib.PrintSequence.print_label_compare_display true "Incremental 2" nn expected computed_incr2 in

  result

  //
  // RESULT
  //

let test () =
  let result1 = test_blake2 "TEST 1" Spec.Blake2.Blake2S test1_expected test1_plaintext test1_key in
  let result2 = test_blake2 "TEST 2" Spec.Blake2.Blake2S test2_expected test2_plaintext test2_key in
  let result3 = test_blake2 "TEST 3" Spec.Blake2.Blake2S test3_expected test3_plaintext test3_key in
  let result4 = test_blake2 "TEST 4" Spec.Blake2.Blake2S test4_expected test4_plaintext test4_key in
  let result5 = test_blake2 "TEST 5" Spec.Blake2.Blake2B test5_expected test5_plaintext test5_key in
  if result1 && result2 && result3 && result4 && result5 then IO.print_string "\n\nSuccess !\n"
  else IO.print_string "\n\nFailure !\n";

  ()

