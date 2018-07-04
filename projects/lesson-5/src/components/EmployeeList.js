import React, { Component } from 'react'
import { Table, Button, Modal, Form, InputNumber, Input, message, Popconfirm } from 'antd';

import EditableCell from './EditableCell';

const FormItem = Form.Item;

const columns = [{
  title: '地址',
  dataIndex: 'address',
  key: 'address',
}, {
  title: '薪水',
  dataIndex: 'salary',
  key: 'salary',
}, {
  title: '上次支付',
  dataIndex: 'lastPaidDay',
  key: 'lastPaidDay',
}, {
  title: '操作',
  dataIndex: '',
  key: 'action'
}];

class EmployeeList extends Component {
  constructor(props) {
    super(props);

    this.state = {
      loading: true,
      employees: [],
      showModal: false
    };

    columns[1].render = (text, record) => (
      <EditableCell
        value={text}
        onChange={ this.updateEmployee.bind(this, record.address) }
      />
    );

    columns[3].render = (text, record) => (
      <Popconfirm title="你确定删除吗?" onConfirm={() => this.removeEmployee(record.address)}>
        <a href="#">Delete</a>
      </Popconfirm>
    );
  }

  componentDidMount() {
    const { payroll, account, web3 } = this.props;
    payroll.checkInfo.call({
      from: account
    }).then((result) => {
      const employeeCount = result[2].toNumber();

      if (employeeCount === 0) {
        this.setState({loading: false});
        return;
      }

      this.loadEmployees(employeeCount);
    });

  }

  loadEmployees(employeeCount) {
    const { payroll, account, web3 } = this.props;
    var employees = [];
    for(let index = 0; index < employeeCount; index++){
      payroll.getEmployeeInfo(index,{
        from:account
      }).then(result =>{
        var temp = {
          key:result[0],
          address:result[0],
          salary:web3.fromWei(result[1].toNumber()),
          lastPaidDay:new Date(result[2].toNumber() * 1000 ).toString()
        };
        console.log(temp);
        employees.push(temp);
        this.setState({
          employees:employees,
          loading:false
        });
      })
    }
    
  }

  addEmployee = () => {
    const { payroll, account, web3 } = this.props;
    const {employeeId , salary} = this.state;
    console.log('addEmployee --'+account);
    console.log('addEmployee -- address:'+this.state.address);
    console.log('addEmployee -- salary:'+salary);
    payroll.addEmployee(
      this.state.address
      ,web3.toWei(salary)
      ,{
        from:account,
        gas:1000000
      }).then(()=>{
        alert('success');
      }).catch(error=>{
        alert(error);
      });
  }

  updateEmployee = (address, salary) => {
    console.log('updateEmployee--'+address + '---' + salary);
    const { payroll, account, web3 } = this.props;
    console.log('account:'+account);
      payroll.updateEmployee(address,salary,{
        from:account,
        gas:1000000
      }).then(()=>{
        alert('success');
      });
  }

  removeEmployee = (employeeId) => {
    const { payroll, account, web3 } = this.props;
      payroll.removeEmployee(employeeId,{
        from:account,
        gas:1000000
      }).then(()=>{
        alert('success');
      });
  }

  renderModal() {
      return (
      <Modal
          title="增加员工"
          visible={this.state.showModal}
          onOk={this.addEmployee}
          onCancel={() => this.setState({showModal: false})}
      >
        <Form>
          <FormItem label="地址">
            <Input
              onChange={ev => this.setState({address: ev.target.value})}
            />
          </FormItem>

          <FormItem label="薪水">
            <InputNumber
              min={1}
              onChange={salary => this.setState({salary})}
            />
          </FormItem>
        </Form>
      </Modal>
    );

  }

  render() {
    const { loading, employees } = this.state;
    return (
      <div>
        <Button
          type="primary"
          onClick={() => this.setState({showModal: true})}
        >
          增加员工
        </Button>

        {this.renderModal()}

        <Table
          loading={loading}
          dataSource={employees}
          columns={columns}
        />
      </div>
    );
  }
}

export default EmployeeList
